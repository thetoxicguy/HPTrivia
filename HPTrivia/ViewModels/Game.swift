//
//  Game.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 03/02/26.
//

import SwiftUI

@Observable
class Game {
    var bookQuestions = BookQuestions()
    
    var gameScore = 0
    var questionScore = 5
    var recentScores = [0, 0, 0]
    
    var activeQuestions: [Question] = [] // The questions for the selected books
    var answeredQuestions: [Int] = []
    var currentQuestion = try! JSONDecoder().decode([Question].self, from: Data(contentsOf: Bundle.main.url(forResource: "trivia", withExtension: "json")!))[0]
    
    var answers: [String] = []
    
    let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(path: "RecentScores.json")
    
    init() {
        loadScores()
    }
    
    func startGame() {
        // populate activeQuestions
        for book in bookQuestions.books {
            if book.status == .active {
                for question in book.questions {
                    activeQuestions.append(question)
                }
            }
        }
        // Go to next question
        newQuestion()
    }
    
    func newQuestion() {
        if answeredQuestions.count == activeQuestions.count {
            answeredQuestions = []
        }
        currentQuestion = activeQuestions.randomElement()!
        
        while(answeredQuestions.contains(currentQuestion.id)) {
            currentQuestion = activeQuestions.randomElement()!
        }
        
        // Set all the suggested answers for this question
//        1. Reset the answers array
        answers = []
//        2. Add the correct answer first
        answers.append(currentQuestion.answer)
//        3. Add all the wrong answers
        for answer in currentQuestion.wrong {
            answers.append(answer)
        }
//        4. Randomize the answers array
        answers.shuffle()
        
        questionScore = 5
    }
    
    func correct() {
        answeredQuestions.append(currentQuestion.id)
//        This depends on an animation in the Gameplay View
        withAnimation {
            gameScore += questionScore
        }
        
    }
    
    func endGame() {
        // Update the recent scores
        recentScores[2] = recentScores[1]
        recentScores[1] = recentScores[0]
        recentScores[0] = gameScore
        
        // reset for the next game
        gameScore = 0
        activeQuestions = []
        answeredQuestions = []
        
        saveScores()
    }
    
    func saveScores() {
        do {
            let data = try JSONEncoder().encode(recentScores)
            try data.write(to: savePath)
        } catch {
            print("Failed to save scores: \(error)")
        }
    }
    
    func loadScores() {
        do {
            let data = try Data(contentsOf: savePath)
            recentScores = try JSONDecoder().decode([Int].self, from: data)
        } catch {
            recentScores = [0, 0, 0]
        }
    }
}
