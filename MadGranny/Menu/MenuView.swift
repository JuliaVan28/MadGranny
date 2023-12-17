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
    
    @Binding var highScore: Int

    @Binding var currentGameState: GameState
    
    var body: some View {
        
        ZStack{
            Image("menu_background_parket")
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 15.0) {
                HStack {
                    ZStack {
                        Image("score_background-2")
                            .resizable()
                            .frame(width: 130, height: 60)
                            .padding([.bottom, .leading, .trailing], 15)
                        HStack {
                            Spacer()
                            Text("\(highScore)")
                                .font(.system(size: 25, weight: .bold))
                        }.frame(width: 90)
                            .padding(.bottom, 15)

                    }
                    Spacer()
                    Image("question-btn")
                        .resizable()
                        .frame(width: 56, height: 56)
                        .padding(.top, 3)
                        .padding([.bottom, .leading, .trailing], 15)
                }
                Spacer()
                ZStack {
                    VStack() {
                        Spacer()
                        Image("big_granny")
                            .resizable()
                            .frame(width: 200, height: 350)
                            .padding(.bottom, 30)
                    }
                    VStack(alignment: .trailing) {
                            Image("dinner_ready")
                                .resizable()
                                .frame(width: 340, height: 180)
                                .padding(.top, 10)
                        Spacer()

                    }
                }

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
    MenuView(highScore: .constant(234), currentGameState: .constant(GameState.menuScreen))
}
