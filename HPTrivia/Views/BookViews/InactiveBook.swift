//
//  InactiveBook.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 03/02/26.
//

import SwiftUI

struct InactiveBook: View {
    @State var book: Book
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(book.image)
                .resizable()
                .scaledToFit()
                .shadow(radius: 7)
                .overlay {
                    Rectangle().opacity(0.33)
                }
            Image(systemName: "circle")
                .font(.largeTitle)
                .imageScale(.large)
                .foregroundStyle(.green.opacity(0.5))
                .shadow(radius: 1)
                .padding(3)
        }
    }
}

#Preview {
    InactiveBook(book: BookQuestions().books[1])
}
