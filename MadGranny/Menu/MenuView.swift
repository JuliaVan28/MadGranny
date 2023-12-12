//
//  WelcomeView.swift
//  MadGranny
//
//  Created by Yuliia on 07/12/23.
//

import SwiftUI
/**
 * # MainScreenView
 *   This view is responsible for presenting the game name, the game intro and to start the game.
 **/
struct MenuView: View {
    @Binding var currentGameState: GameState
    
    var body: some View {
        
        ZStack{
            
            Image("brown_background")
                .resizable()
                .frame(width: 800, height: 900)
            
            
            Image("big_granny")
                .resizable()
                .frame(width: 350, height: 500)
            VStack(alignment: .center, spacing: 16.0) {
                
                Button {
                    withAnimation { self.startGame() }
                } label: {
                    Image("play_button1")
                    
                }
                .padding(.top, 650)
                .foregroundColor(.white)
            }
            .padding()
            .statusBar(hidden: true)
            
        }
    }
    
    
    /**
     * Function responsible to start the game.
     * It changes the current game state to present the view which houses the game scene.
     */
    private func startGame() {
        print("- Starting the game...")
        self.currentGameState = .playing
    }
}

#Preview {
    MenuView(currentGameState: .constant(GameState.menuScreen))
}
