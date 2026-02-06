//
//  SelectBooks.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 03/02/26.
//

import SwiftUI

struct SelectBooks: View {
    @Environment(\.dismiss) private var dismiss
//    Game.self is the type of environment model to set the variable
    @Environment(Game.self) var game
    
    private var store = Store()
    
    var activeBooks: Bool {
        for book in game.bookQuestions.books {
            if book.status == .active {
                return true
            }
        }
        return false
    }

    var body: some View {
        ZStack {
            Image(.parchment)
                .resizable()
                .ignoresSafeArea()
                .background(.brown)
            
            VStack {
                Text ("Which books would you like to see questions from?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(game.bookQuestions.books) { book in
                            if book.status == .active || (book.status == .locked && store.purchased.contains(book.image)) {
                                ActiveBook(book: book)
                                    .onTapGesture {
                                        game.bookQuestions.changeStatus(of: book.id, to: .inactive)
                                    }
                                    .task {
                                        game.bookQuestions.changeStatus(of: book.id, to: .active) 
                                    }
                                }
                            else if book.status == .inactive {
                                InactiveBook(book: book)
                                .onTapGesture {
                                    game.bookQuestions.changeStatus(of: book.id, to: .active)
                                }
                            } else {
                                LockedBook(book: book)
                                .onTapGesture {
                                    let product = store.products[book.id-4]
                                    Task {
                                        await store.purchase(product)
                                    }
                                }
                            }
                        }
                    }
                }
                if !activeBooks {
                    Text("You must select at least 1 book to play")
                        .multilineTextAlignment(.center)
                }
                Button("Done") {
                    game.bookQuestions.saveStatus()
                    dismiss()
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(.borderedProminent)
                .tint(.brown.mix(with: .black, by: 0.2))
                .foregroundStyle(.white)
                .disabled(!activeBooks)
            }
            .foregroundStyle(.black)
        }
//        For storing the status to persist it is complex to set it on dismissal
//        .interactiveDismissDisabled(!activeBooks)
        .interactiveDismissDisabled() // Default to true
        .task {
            await store.loadProducts()
        }
    }
}

#Preview {
    SelectBooks()
//    It is not important for the preview which environment we are setting, just a generic instance
        .environment(Game())
}
