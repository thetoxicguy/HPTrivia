//
//  ButtonBar.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 28/01/26.
//

import SwiftUI

struct ButtonBar: View {
    @Binding var animateViewsIn: Bool
    @Binding var playGame: Bool

    let geo: GeometryProxy

    var body: some View {
        HStack {
            Spacer()
            InstructionsButton(
                animateViewsIn: $animateViewsIn,
                geo: geo
            )
            Spacer()
            PlayButton(animateViewsIn: $animateViewsIn, playGame: $playGame, geo: geo)
            Spacer()
            SettingsButton(animateViewsIn: $animateViewsIn, geo: geo)
            
            Spacer()
        }
        .frame(width: geo.size.width)
    }
}

#Preview {
    GeometryReader { geo in
        ButtonBar(animateViewsIn: .constant(true), playGame: .constant(false), geo: geo)
    }
}
