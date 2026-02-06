//
//  Gameplay.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 03/02/26.
//

import SwiftUI
import AVKit

struct Gameplay: View {
//    We bring the Game object as our environment
    @Environment(Game.self) var game

//    We take the dismiss action from the dismiss environment
    @Environment(\.dismiss) var dismiss
    
    @Namespace private var namespace
    
    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!
    @State private var animateViewsIn = false
    @State private var revealHint = false
    @State private var revealBook = false
    @State private var tappedCorrectAnswer = false
    @State private var wrongAnswersTapped: [String] = []
    @State private var movePointsToScore = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height * 1.05)
                    .overlay {
                        Rectangle()
                            .foregroundStyle(.black.opacity(0.8))
                    }
//                MARK: Before correct answer
                VStack {
                    // MARK: Controls
                    HStack {
                        Button("End game") {
                            game.endGame()
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        
                        Spacer()
                        
                        Text("Score: \(game.gameScore)")
                    }
                    .padding()
                    .padding(.vertical, 30)
                    
                    VStack {
                        // MARK: Question
                        VStack {
                            if animateViewsIn {
                                Text(game.currentQuestion.question)
                                    .font(.custom("PartyLetPlain", size: 50))
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                        }
//                        Animate when answering correctly, not when tapping the "Next Question" button (based on animateViewsIn)
                        .animation(.easeInOut(duration: animateViewsIn ? 2 : 0), value: animateViewsIn)
                        
                        Spacer()
                        
                        // MARK: Hints
                        HStack {
                            VStack {
                                if animateViewsIn {
                                    Image(systemName: "questionmark.app.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100)
                                        .foregroundStyle(.cyan)
                                        .padding()
                                        .transition(.offset(x: -geo.size.width / 2))
                                        .phaseAnimator([false, true]) { content, phase in
                                            content
                                                .rotationEffect(.degrees(phase ? -13 : -17))
                                        } animation: { _ in
                                                .easeInOut(duration: 0.7)
                                        }
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 1)) {
                                                revealHint = true
                                            }
                                            playFlipSound()
                                            game.questionScore -= 1
                                        }
                                        .rotation3DEffect(
                                            .degrees(revealHint ? 1440 : 0),
                                            axis: (x: 0, y: 1, z: 0)
                                        )
                                        .scaleEffect(revealHint ? 5 : 1)
                                        .offset(x: revealHint ? geo.size.width / 2 : 0)
                                        .opacity(revealHint ? 0 : 1)
                                        .overlay {
                                            Text(game.currentQuestion.hint)
                                                .padding(.leading, 20)
                                                .minimumScaleFactor(0.5)
                                                .multilineTextAlignment(.center)
                                                .opacity(revealHint ? 1 : 0)
                                                .scaleEffect(revealHint ? 1.33 : 1)
                                        }
                                }
                            }
//                        Animate when answering correctly, not when tapping the "Next Question" button (based on animateViewsIn) animateViewsIn ? 1.5 : 0
                            .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
                            
                            Spacer()
                            
                            VStack {
                                if animateViewsIn {
                                    Image(systemName: "app.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100)
                                        .foregroundStyle(.cyan)
                                        .overlay {
                                            Image(systemName: "book.closed")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50)
                                                .foregroundStyle(.black)
                                        }
                                        .padding()
                                        .transition(.offset(x: geo.size.width / 2))
                                        .phaseAnimator([false, true]) { content, phase in
                                            content
                                                .rotationEffect(.degrees(phase ? 13 : 17))
                                        } animation: { _ in
                                                .easeInOut(duration: 0.7)
                                        }
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 1)) {
                                                revealBook = true
                                            }
                                            playFlipSound()
                                            game.questionScore -= 1
                                        }
                                        .rotation3DEffect(
                                            .degrees(revealBook ? -1440 : 0),
                                            axis: (x: 0, y: 1, z: 0)
                                        )
                                        .scaleEffect(revealBook ? 5 : 1)
                                        .offset(x: revealBook ? -geo.size.width / 2 : 0)
                                        .opacity(revealBook ? 0 : 1)
                                        .overlay {
                                            //                                        This computed property doesn't work for some reason
                                            //                                        Image(game.currentQuestion.book.image)
                                            Image("hp\(game.currentQuestion.book)")
                                                .resizable()
                                                .scaledToFit()
                                                .padding(.trailing, 20)
                                                .opacity(revealBook ? 1 : 0)
                                                .scaleEffect(revealBook ? 1.33 : 1)
                                        }
                                }
                            }
//                        Animate when answering correctly, not when tapping the "Next Question" button (based on animateViewsIn) animateViewsIn ? 2 : 0
                            .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
                        }
                        .padding()
                        
                        // MARK: Answers
                        LazyVGrid(columns: [GridItem(), GridItem()]) {
                            ForEach(game.answers, id: \.self) { answer in
                                if answer == game.currentQuestion.answer {
                                    VStack {
                                        if animateViewsIn {
                                            if !tappedCorrectAnswer {
                                                Button {
                                                    withAnimation(.easeOut(duration: 1)) {
                                                        tappedCorrectAnswer = true
                                                    }
                                                    playCorrectSound()
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                                        game.correct()
                                                    }
                                                } label: {
                                                    Text(answer)
                                                        .minimumScaleFactor(0.5)
                                                        .multilineTextAlignment(.center)
                                                        .padding(10)
                                                        .frame(
                                                            width: geo.size.width / 2.15,
                                                            height: 80
                                                        )
                                                        .background(.green.opacity(0.5))
                                                        .clipShape(.rect(cornerRadius: 25))
                                                    //                                                Like a ref in React (the reference is "namespace"
                                                        .matchedGeometryEffect(id: 1, in: namespace)
                                                }
                                                .transition(.asymmetric(insertion: .scale, removal: .scale(scale: 3).combined(with: .opacity)))
                                            }
                                        }
                                    }
//                        Animate when answering correctly, not when tapping the "Next Question" button (based on animateViewsIn) animateViewsIn ? 2 : 0
                                    .animation(.easeOut(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1.5 : 0), value: animateViewsIn)
                                } else {
                                    VStack {
                                        if animateViewsIn {
                                            Button {
                                                withAnimation(.easeOut(duration: 1)) {
                                                    wrongAnswersTapped.append(answer)
                                                }
                                                playWrongSound()
                                                game.questionScore -= 1
                                            } label: {
                                                Text(answer)
                                                    .minimumScaleFactor(0.5)
                                                    .multilineTextAlignment(.center)
                                                    .padding(10)
                                                    .frame(
                                                        width: geo.size.width / 2.15,
                                                        height: 80
                                                    )
                                                    .background(wrongAnswersTapped .contains(answer) ? .red.opacity(0.5) : .green.opacity(0.5))
                                                    .clipShape(.rect(cornerRadius: 25))
                                                    .scaleEffect(wrongAnswersTapped .contains(answer) ? 0.8 : 1)
                                            }
                                            .transition(.scale)
                                            //                                        When wrongAnswersTapped changes, the feedback is triggered
                                            .sensoryFeedback(.error, trigger: wrongAnswersTapped)
                                            .disabled(wrongAnswersTapped.contains(answer))
                                        }
                                    }
//                        Animate when answering correctly, not when tapping the "Next Question" button (based on animateViewsIn)
                                    .animation(.easeOut(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1.5 : 0), value: animateViewsIn)
                                }
                            }
                        }
                        Spacer()
                    }
                    .disabled(tappedCorrectAnswer)
                    .opacity(tappedCorrectAnswer ? 0.1 : 1)
                }
                .frame(width: geo.size.width, height: geo.size.height)
                
                // MARK: Celebration
                VStack {
                    Spacer()
                    VStack {
                        if tappedCorrectAnswer {
                            Text("\(game.questionScore)")
                                .font(.largeTitle)
                                .padding(.top, 50)
                                .transition(.offset(y: -geo.size.height/4))
                                .offset(
                                    x: movePointsToScore ? geo.size.width / 2.3 : 0,
                                    y: movePointsToScore ? -geo.size.height / 13 : 0
                                )
                                .opacity(movePointsToScore ? 0 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1).delay(3)) {
                                        movePointsToScore = true
                                    }
                                }
                        }
                    }
                    .animation(.easeInOut(duration: 1).delay(2), value: tappedCorrectAnswer)
                    Spacer()
                    VStack {
                        if tappedCorrectAnswer {
                            Text("Brilliant!")
                                .font(.custom("PartyLetPlain", size: 100))
                                .transition(.scale.combined(with: .offset(y: -geo.size.height / 2)))
                        }
                    }
//                        Animate when answering correctly, not when tapping the "Next Question" button (based on tappedCorrectAnswer)
                    .animation(.easeInOut(duration: tappedCorrectAnswer ? 1 : 0).delay(tappedCorrectAnswer ? 1.5 : 0), value: tappedCorrectAnswer)
                    Spacer()
                    if tappedCorrectAnswer {
                        Text(game.currentQuestion.answer)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .frame(width: geo.size.width / 2.15, height: 80)
                            .background(.green.opacity(0.5))
                            .clipShape(.rect(cornerRadius: 25))
                            .scaleEffect(2)
                            .matchedGeometryEffect(id: 1, in: namespace)
                    }
                    Spacer()
                    Spacer()
                    VStack {
                        if tappedCorrectAnswer {
                            Button("Next Question →") {
//                                Reset the question's state
                                animateViewsIn = false
                                revealHint = false
                                revealBook = false
                                tappedCorrectAnswer = false
                                wrongAnswersTapped = []
                                movePointsToScore = false

//                                Set the new question
                                game.newQuestion()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    animateViewsIn = true
                                }
                            }
                            .font(.largeTitle)
                            .buttonStyle(.borderedProminent)
                            .tint(.blue.opacity(0.5))
                            .transition(.offset(y: geo.size.height/3))
                            .phaseAnimator([false , true]) { content, phase in
                                content
                                    .scaleEffect(phase ? 1.2 : 1)
                            } animation: { _ in
                                    .easeInOut(duration: 1.3)
                            }
                        }
                    }
//                        Animate when answering correctly, not when tapping the "Next Question" button (based on tappedCorrectAnswer)
                    .animation(.easeInOut(duration: tappedCorrectAnswer ? 2.7 : 0).delay(tappedCorrectAnswer ? 2.7 : 0), value: tappedCorrectAnswer)
                    Spacer()
                    Spacer()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .foregroundStyle(.white)
        }
        .ignoresSafeArea()
        .onAppear {
            game.startGame()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animateViewsIn = true
            }
            
//            Add a delay of 2 seconds for the music to start
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                playMusic()
            }
        }
    }
    private func playMusic() {
        let songs = [
            "let-the-mistery-unfold",
            "spellcraft",
            "hiding-place-in-the-forest",
            "deep-in-the-dell"
        ]
        
        let song = songs.randomElement()!
        let sound = Bundle.main.path(forResource: song, ofType: "mp3")
        
        musicPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        musicPlayer.volume = 0.1
        musicPlayer.numberOfLoops = -1
        musicPlayer.play()
    }
    
    private func playFlipSound() {
        let sound = Bundle.main.path(forResource: "page-flip", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }
    
    private func playWrongSound() {
        let sound = Bundle.main.path(forResource: "negative-beeps", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }
    
    private func playCorrectSound () {
        let sound = Bundle.main.path(forResource: "magic-wand", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }
}

#Preview {
    Gameplay()
        .environment(Game())
}
