//
//  ContentView.swift
//  MadGranny
//
//  Created by Yuliia on 07/12/23.
//

import SwiftUI
/**
 * # ContentView
 *
 *   This view is responsible for managing the states of the game, presenting the proper view.
 **/

struct ContentView: View {
    
    // The navigation of the app is based on the state of the game.
    // Each state presents a different view on the SwiftUI app structure
    @State var currentGameState: GameState = .menuScreen
    
    // The game logic is a singleton object shared among the different views of the application
    @StateObject var gameLogic: GameLogic = GameLogic()
    
    //Persistently stores highScore of the user
    @AppStorage("highScore") var highScore: Int = 0

    
    var body: some View {
        switch currentGameState {
        case .menuScreen:
            MenuView(highScore: $highScore, currentGameState: $currentGameState)
                .environmentObject(gameLogic)
        
        case .playing:
            GameView(highScore: $highScore, currentGameState: $currentGameState)
                .environmentObject(gameLogic)
        
        case .gameResults:
            GameResultsView(currentGameState: $currentGameState, highScore: $highScore)
                .environmentObject(gameLogic)
            
        case .instruction:
            InstructionView(currentGameState: $currentGameState)
                .environmentObject(gameLogic)
        }
    }
}

#Preview {
    ContentView()
}
