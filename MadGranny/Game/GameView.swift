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
        print("Game scene is created")
        print("game state is \(self.currentGameState)")

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
                
            HStack {
                GameTimerView(time: $gameLogic.timerDuration)
                    //.padding()
                
                GamePointsView(score: $gameLogic.currentScore)
                    //.padding()
                
                Button(action: {print("")}) {
                    Image(systemName: "pause")
                        .font(.headline)
                }
                    .frame(minWidth: 60)
                    .padding(24)
                    .foregroundColor(.white)
                    .background(Color(UIColor.systemGray))
                    .cornerRadius(10)
                    //.padding()
            }
            
            .padding(.top, 20)
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
           // gameLogic.restartGame()
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
