//
//  Question.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 27/01/26.
//

struct Question: Decodable {
    let id: Int
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    let book: String
    let hint: String
}
