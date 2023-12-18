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
    
    @Binding var highScore: Int

    @Binding var currentGameState: GameState
    
    @StateObject var gameScene: GameScene = {
        let scene = GameScene()
        print("Game scene is created")

        scene.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        scene.scaleMode = .fill
        //scene.addChild(SoundManager.sharedInstance.soundBackground
        
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
                GameScoreView().environmentObject(gameLogic)
                Spacer()
                Button(action: {
                    if gameLogic.isPaused {
                        gameScene.resumeGame()
                        gameLogic.startTimer()
                    } else {
                        gameLogic.stopTimer()

                    }
                }) {
                    Image(gameLogic.isPaused ? "play-btn" : "pause-btn")
                        .resizable()
                        .frame(width: 56, height: 56)
                        .padding(.top, 3)
                    
                }
            }
            .padding(.top, 30)
            .padding()
        }
        .onChange(of: gameLogic.isGameOver) {
            print("gameLogic.isGameOver is changed to \(gameLogic.isGameOver)")
            print("game state is \(self.currentGameState)")
            if gameLogic.isGameOver {
                print("in gameView highScore is \(highScore), curScore is \(gameLogic.currentScore)")
                setHighScore()
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
    
    private func setHighScore() {
        if highScore < gameLogic.currentScore {
            highScore = gameLogic.currentScore
            print("new highScore \(highScore)")
        }
    }
}

#Preview {
    GameView(highScore: .constant(234), currentGameState: .constant(GameState.playing))
}
