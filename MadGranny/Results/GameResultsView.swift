//
//  GameResultsView.swift
//  MadGranny
//
//  Created by Yuliia on 07/12/23.
//

import SwiftUI

struct GameResultsView: View {
    
    // The game state is used to transition between the different states of the game
    @Binding var currentGameState: GameState
    
    @StateObject var gameLogic: GameLogic =  GameLogic.shared
    
    @Binding var highScore: Int

    var body: some View {
        ZStack {
            
            Image("menu_background_parket")
                .resizable()
                .ignoresSafeArea()
            
            VStack(){
                
                Image("gameOver")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .padding(.top, 90)
                
                HStack{
                    Image("result_child")
                    
                    Spacer().frame(width: 20)
                    
                    Image("result_granny")
                        .padding(.bottom,20)
                }
                .padding(.bottom, 60)
                
                Image("your_score")
                
                ZStack(){
                    Image("score_background-2")
                        .resizable()
                        .frame(width: 150, height: 80)
                        .padding([.bottom, .leading, .trailing], 5)
                    
                    Text("\(gameLogic.currentScore)")
                        .font(.system(size: 25, weight: .bold))
               }
                .padding(.bottom, 50)
                
                HStack() {
                    Spacer()
                    
                    Button {
                        withAnimation { self.restartGame() }
                    } label: {
                        Image("restart-btn")
                            .resizable()
                            .frame(width: 70, height: 70)
                    }
                    
                    Spacer().frame(width: 100)
                    
                    Button {
                        withAnimation { self.backToMainScreen() }
                    } label: {
                        Image("home-btn")
                            .resizable()
                            .frame(width: 70, height: 70)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 250)
            }
        }
        .statusBar(hidden: true)
        .onAppear() {
            print("in gameResultView highScore is \(highScore)")
        }
    }
    
    private func backToMainScreen() {
        self.currentGameState = .menuScreen
    }
    
    private func restartGame() {
        self.currentGameState = .playing
        gameLogic.isGameOver = false
    }
}

#Preview {
    GameResultsView(currentGameState: .constant(GameState.gameResults), highScore: .constant(234))
}

