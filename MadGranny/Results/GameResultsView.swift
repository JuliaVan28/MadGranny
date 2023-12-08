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
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    GameResultsView(currentGameState: .constant(GameState.gameResults))
}
