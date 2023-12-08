//
//  GameView.swift
//  MadGranny
//
//  Created by Yuliia on 07/12/23.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    
    @StateObject var gameLogic: GameLogic =  GameLogic.shared

    @Binding var currentGameState: GameState
    
    private var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
    private var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
    
    var gameScene: GameScene {
        let scene = GameScene()
        
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        
        return scene
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // View that presents the game scene
            SpriteView(scene: self.gameScene)
                .frame(width: screenWidth, height: screenHeight)
                .statusBar(hidden: true)
                .ignoresSafeArea()
            
            HStack() {
                /**
                 * UI element showing the duration of the game session.
                 */
              //  TimerView(time: $gameLogic.timerDuration)
                
                Spacer()
                
                /**
                 * UI element showing the current score of the player.
                 */
               // ScoreView(score: $gameLogic.currentScore)
            
            }
            .padding()
            .padding(.top, 40)
            
        }
        .onChange(of: gameLogic.isGameOver) {
            if gameLogic.isGameOver {
                withAnimation {
                    self.presentGameResultsScreen()
                }
            }
        }
        .onAppear {
            gameLogic.restartGame()
        }
    }
    
    /**
     * ### Function responsible for presenting the main screen
     */
    private func presentMainScreen() {
        self.currentGameState = .menuScreen
    }
    
    /**
     * ### Function responsible for presenting the game over screen.
     */
    private func presentGameResultsScreen() {
        self.currentGameState = .gameResults
    }
}

#Preview {
    GameView(currentGameState: .constant(GameState.playing))
}