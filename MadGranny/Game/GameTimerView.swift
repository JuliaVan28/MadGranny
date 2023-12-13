//
//  GameDurationView.swift
//  MadGranny
//
//  Created by Vanda Savkina on 08/12/23.
//

import SwiftUI
import Foundation

/**
 * # GameDurationView
 * Custom UI to present how many seconds have passed since the beginning of the gameplay session.
 *
 * Customize it to match the visual identity of your game.
 */

struct GameTimerView: View {
    @StateObject var gameLogic: GameLogic =  GameLogic.shared
    
    var body: some View {
        HStack {
            Text("\(gameLogic.timerDuration.asTimestamp)")
                .font(.system(size: 22, weight: .bold))
                .onReceive(gameLogic.timer) { input in
                    gameLogic.timerDuration += 1
                }
            
        }
        .frame(width: 90)
        .padding(10)
        .foregroundColor(.black)
        .background(Material.ultraThin)
        .cornerRadius(10)
    }
    
}

#Preview {
    GameTimerView()
        .previewLayout(.fixed(width: 300, height: 100))
}

