//
//  HPTriviaApp.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 26/01/26.
//

import SwiftUI

@main
struct HPTriviaApp: App {
    // We are setting a variable to use as an environment (something like a Context variable)
    private var game = Game()
    var body: some Scene {
        WindowGroup {
            ContentView()
//            Here we use the variable for the environment (like setting the context in this file to be distributed
                .environment(game)
        }
    }
}

/*
 App Development Plan
 🟦 Game Intro Screen
 - Gameplay screen
 - Game logic (questions, scores, etc)
 - Celebration
 🟧 Audio
 🟧 Animations
 - In-app purchases
 - Store
 ✅ Instruction screen
 🟦 Books
 - Persist scores
*/

/*
 🟧 Started
 🟦 In Progress
 ✅ Done
*/
