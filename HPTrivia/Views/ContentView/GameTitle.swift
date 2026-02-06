//
//  GameTitle.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 28/01/26.
//

import SwiftUI

struct GameTitle: View {
//    Binding is the action of receiving @State from parent
    @Binding var animateViewsIn: Bool
    var body: some View {
        //                    Animate text, step 3 alt (Seet the animation based on the state for the if statement)
        VStack {
            //                    Animate text, step 4 (Seet the animation based on the state)
            if animateViewsIn {
                VStack {
                    Image(systemName: "wand.and.sparkles")
                        .imageScale(.large)
                        .font(.largeTitle)
                        .padding()
                    Text("Harry Potter")
                        .font(.custom("PartyLetPlain", size: 70))
                        .padding(.bottom, -50)
                    Text("Trivia")
                        .font(.custom("PartyLetPlain", size: 60))
                }
                .padding(.top, 70)
                //                    Animate text, step 2 (Configure the transition)
                .transition(.move(edge: .top))
            }
        }
        //                    Animate text, step 3 alt (Animate for the specific state: animateViewsIn)
        .animation(.easeOut(duration: 0.7).delay(0.6), value: animateViewsIn)
    }
}

#Preview {
    GameTitle(animateViewsIn: .constant(true))
}
