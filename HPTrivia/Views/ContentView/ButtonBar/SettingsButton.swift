//
//  SettingsButton.swift
//  HPTrivia
//
//  Created by daniel.a.robles on 28/01/26.
//

import SwiftUI

struct SettingsButton: View {
    @State private var showSettings = false
    
    @Binding var animateViewsIn: Bool
    
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            if animateViewsIn {
                Button {
                    showSettings.toggle()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .shadow(radius: 5)
                }
                .transition(.offset(x: geo.size.width / 4))
            }
        }
        .animation(.easeInOut(duration: 0.7).delay(3.4), value: animateViewsIn)
    }
}

#Preview {
    GeometryReader { geo in
        SettingsButton(animateViewsIn: .constant(true), geo: geo)
    }
}
