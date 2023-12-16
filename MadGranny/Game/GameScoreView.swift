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

struct GameScoreView: View {
    @StateObject var gameLogic: GameLogic =  GameLogic.shared
    
    @State var scoreValue: Int = 0
    
    var body: some View {
        
        ZStack {
            Image("score_background-2")
                .resizable()
                .frame(width: 130, height: 60)
            HStack {
                Spacer()
                Text("\(scoreValue)")
                    .contentTransition(.numericText())
                    .font(.system(size: 25, weight: .bold))
                    .onReceive(gameLogic.timer) { input in
                        withAnimation() {
                            gameLogic.timerDuration += 1
                            gameLogic.score(points: 1)
                            scoreValue = gameLogic.currentScore
                        }
                    }
                    .onChange(of: gameLogic.currentScore) {
                        withAnimation(.default.speed(0.8)) {
                            scoreValue = gameLogic.currentScore
                        }
                    }
                
            }
            .frame(width: 90)
           // .padding(10)
            .foregroundColor(.black)
            
        }
    }
    
}

#Preview {
    GameScoreView()
    // .previewLayout(.fixed(width: 300, height: 100))
}

