//
//  Book.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 29/01/26.
//

struct Book: Identifiable, Decodable {
    let id: Int
    let image: String
    let questions: [Question]
    var status: BookStatus
}

enum BookStatus: String, Decodable {
    case active, inactive, locked
}
