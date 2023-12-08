//
//  GameDurationView.swift
//  MadGranny
//
//  Created by Vanda Savkina on 08/12/23.
//

import SwiftUI

/**
 * # GameDurationView
 * Custom UI to present how many seconds have passed since the beginning of the gameplay session.
 *
 * Customize it to match the visual identity of your game.
 */

struct GameTimerView: View {
    @Binding var time: TimeInterval
    
    var body: some View {
        HStack {
            Image(systemName: "clock")
                .font(.headline)
            Spacer()
            Text("\(Int(time))")
                .font(.headline)
        }
        .frame(minWidth: 50)
        .padding(24)
        .foregroundColor(.white)
        .background(Color(UIColor.systemGray))
        .cornerRadius(10)
    }
}

#Preview {
    GameTimerView(time: .constant(1000))
        .previewLayout(.fixed(width: 300, height: 100))
}
