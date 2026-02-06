//
//  RecentScores.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 28/01/26.
//

import SwiftUI

struct RecentScores: View {
//    We bring the Game() object for our environment
    @Environment(Game.self) private var game
    
    @Binding var animateViewsIn: Bool
    var body: some View {
        VStack {
            if animateViewsIn {
                VStack {
                    Text("Recent Scores")
                        .font(.title2)
                    Text("\(game.recentScores[0])")
                    Text("\(game.recentScores[1])")
                    Text("\(game.recentScores[2])")
                }
                .font(.title3)
                .foregroundStyle(.white)
                .padding(.horizontal)
                .background(.black.opacity(0.7))
                .clipShape(.rect(cornerRadius: 15))
                .transition(.opacity)
            }
        }
        .animation(.linear(duration: 1.7).delay(4.8), value: animateViewsIn)
    }
}

#Preview {
    RecentScores(animateViewsIn: .constant(true))
        .environment(Game())
}
