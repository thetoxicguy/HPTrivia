//
//  PlayButton.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 28/01/26.
//

import SwiftUI

struct PlayButton: View {
    @State private var playGame = false
    @State private var scalePlayButton = false
    @Binding var animateViewsIn: Bool
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            if animateViewsIn {
                Button {
                    playGame.toggle()
                } label: {
                    Text("Play")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 50)
                        .background(.purple)
                        .clipShape(.capsule)
                        .shadow(radius: 5)
                        .scaleEffect(scalePlayButton ? 1.2 : 1)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1).repeatCount(9)) {
                                scalePlayButton.toggle()
                            }
                        }
                }
                .transition(.offset(y: geo.size.height / 3))
            }
        }
        .animation(.easeOut(duration: 0.7).delay(1.9), value: animateViewsIn)
    }
}

#Preview {
    GeometryReader { geo in
        PlayButton(animateViewsIn: .constant(true), geo: geo)
    }
}
