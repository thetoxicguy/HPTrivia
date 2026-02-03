//
//  LockedBook.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 03/02/26.
//

import SwiftUI

struct LockedBook: View {
    @State var book: Book
    var body: some View {
        ZStack {
            Image(book.image)
                .resizable()
                .scaledToFit()
                .shadow(radius: 7)
                .overlay {
                    Rectangle().opacity(0.70)
                }
            Image(systemName: "lock.fill")
                .font(.largeTitle)
                .imageScale(.large)
                .shadow(color: .white, radius: 2)
        }
    }
}

#Preview {
    LockedBook(book: BookQuestions().books[2])
}
