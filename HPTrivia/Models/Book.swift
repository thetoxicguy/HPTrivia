//
//  Book.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 29/01/26.
//

// Codable comprehends both: Decodable and Encodable
struct Book: Identifiable, Codable {
    let id: Int
    let image: String
    let questions: [Question]
    var status: BookStatus
}

enum BookStatus: String, Codable {
    case active, inactive, locked
}
