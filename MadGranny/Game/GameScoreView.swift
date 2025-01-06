//
//  GameDurationView.swift
//  MadGranny
//
//  Created by Vanda Savkina on 08/12/23.
//

import SwiftUI
import Foundation

struct GameScoreView: View {
    @StateObject var gameLogic: GameLogic =  GameLogic.shared
    
    @State var scoreValue: Int = 0
    
    var body: some View {
        
        ZStack {
            Image("score_background-2")
                .resizable()
                .frame(width: 130, height: 60)
                .overlay {
                    HStack {
                        Spacer()
                        Text("\(scoreValue)")
                            .contentTransition(.numericText())
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
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
                    .frame(width: 100)
                }
                      
        }
    }
    
}

#Preview {
    GameScoreView()
}

