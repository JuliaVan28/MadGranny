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

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Image("gameOver")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 250)
                    .clipped()
                
                    .padding()
                
                  Spacer()//.frame(height: 0)
                
                Image("big_granny_1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 250)
                    .clipped()
                    
                    //.padding()
                
                Spacer()//.frame(height: 100)
                
                HStack() {
                    Spacer()
                    
                    Button {
                        withAnimation { self.restartGame() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.black)
                            .font(.title)
                            .frame(height: 300)
                    }
                    .background(Circle().foregroundColor(Color(uiColor: UIColor.systemGray6)).frame(width: 100, height: 100, alignment: .center))
                    
                    Spacer().frame(width: 130)
                    
                    Button {
                        withAnimation { self.backToMainScreen() }
                    } label: {
                        Image(systemName: "house")
                            .foregroundColor(.black)
                            .font(.title)
                            .frame(height: 300)
                    }
                    .background(Circle().foregroundColor(Color(uiColor: UIColor.systemGray6)).frame(width: 100, height: 100, alignment: .center))
                    
                    
                    Spacer()
                }
                Spacer()
                .padding()
            }
        }
        .statusBar(hidden: true)
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
    GameResultsView(currentGameState: .constant(GameState.gameResults))
}
