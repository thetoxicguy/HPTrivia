//
//  ContentView.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 26/01/26.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
    //                    Animate text, step 1 (Declare the state)
    @State private var animateViewsIn = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                AnimatedBackground(geo: geo)
                VStack {
//                    $ is to inject the @Binding to our @State
                    GameTitle(animateViewsIn: $animateViewsIn)
                    Spacer()
                    RecentScores(animateViewsIn: $animateViewsIn)
                    
                    Spacer()
                    ButtonBar(animateViewsIn: $animateViewsIn, geo: geo)
                    Spacer()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        //                    Animate text, step 3 (Trigger the animation)
        .onAppear {
//            withAnimation{
//                Apply animation (with parameters) to the states listed here
            animateViewsIn = true
            playaudio()
//            }
        }
    }
    private func playaudio() {
        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
        audioPlayer.volume = 0.7
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
    /* As we are using the Game environment,
     we have to set it in the Preview because it will use the SelectBooks View
     */
        .environment(Game())

}
