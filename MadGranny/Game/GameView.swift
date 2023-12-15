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
    
    @StateObject var gameScene: GameScene = {
        let scene = GameScene()
        print("Game scene is created")

        scene.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        scene.scaleMode = .fill
        
        return scene
    }()
    
    var body: some View {
        ZStack(alignment: .top) {
            // View that presents the game scene
            SpriteView(scene: self.gameScene)
                .frame(width: ScreenSize.width, height: ScreenSize.height)
                .statusBar(hidden: true)
                .ignoresSafeArea()
                
            HStack {
                GameTimerView().environmentObject(gameLogic)
                GamePointsView(score: $gameLogic.currentScore)
                Spacer()
                Button(action: {
                    if gameLogic.isPaused {
                        gameScene.resumeGame()
                        gameLogic.startTimer()
                    } else {
                        gameLogic.stopTimer()

                    }
                }) {
                    Image(systemName: gameLogic.isPaused ? "play.fill" : "pause")
                        .font(.system(size: 26))
                        .fontWeight(.black)
                }
                    .frame(width: 30)
                    .padding(10)
                    .foregroundColor(.black)
                    .background(Material.ultraThin)
                    .cornerRadius(10)
                    .padding(.trailing, 10)
            }
            .padding(.top, 30)
            .padding()
        }
        .onChange(of: gameLogic.isGameOver) {
            print("gameLogic.isGameOver is changed to \(gameLogic.isGameOver)")
            print("game state is \(self.currentGameState)")
            if gameLogic.isGameOver {
                withAnimation {
                    self.presentGameResultsScreen()
                }
            }
        }
        .onAppear {
            gameLogic.isGameOver = false
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
