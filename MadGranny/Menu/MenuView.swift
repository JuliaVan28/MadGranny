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
            Image("menu_background_parket")
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 20.0) {
                Spacer()
                ZStack {
                    HStack() {
                        Image("big_granny")
                            .resizable()
                            .frame(width: 200, height: 350)
                            .padding(.leading, 5)
                            .padding(.top, 40)
                        Spacer()
                    }
                    VStack(alignment: .trailing) {
                        HStack {
                            Spacer()
                            Image("dinner_ready")
                                .resizable()
                                .frame(width: 280, height: 180)
                        }
                        Spacer()
                    }
                }.frame(height: 450)

                Button {
                    withAnimation { self.startGame() }
                } label: {
                    Image("play_button1")
                    
                }
                .padding(.bottom, 30)
            }
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
