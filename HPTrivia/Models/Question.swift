//
//  Question.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 27/01/26.
//

struct Question: Decodable {
    let id: Int
    let question: String
    let answer: String
    let wrong: [String]
    let book: Int
    let hint: String
}
