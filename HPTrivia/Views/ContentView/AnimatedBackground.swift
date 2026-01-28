//
//  AnimatedBackground.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 28/01/26.
//

import SwiftUI

struct AnimatedBackground: View {
//    We get the geo object from the parent
    let geo: GeometryProxy
    
    var body: some View {
        Image(.hogwarts)
            .resizable()
            .frame(width: geo.size.width * 3, height: geo.size.height)
            .padding(.top, 3)
        //                Animate the image back and forth in cycles of 60 sec
            .phaseAnimator([false, true]) { content, phase in
                content
                    .offset(
                        x: phase ? geo.size.width/1.1 : -geo.size.width/1.1
                        //                                y: phase ? geo.size.height/5 : -geo.size.height/5
                    )
            } animation: { _ in
                    .linear(duration: 60)
            }
    }
}

#Preview {
    GeometryReader { geo in
        AnimatedBackground(geo: geo)
//        This is only to visualize the image in the right way
            .frame(width: geo.size.width, height: geo.size.height)
    }
    .ignoresSafeArea()
}
