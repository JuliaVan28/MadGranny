//
//  InstructionView.swift
//  MadGranny
//
//  Created by Ali on 17/12/23.
//

import SwiftUI

struct CustomGroupBoxStyle: GroupBoxStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label.foregroundColor(.primary)
            configuration.content
        }
        .padding()
        .background(color)
        .cornerRadius(8)
    }
}

let myColor = Color(red: 159/255.0, green: 215/255.0, blue: 224/255.0, opacity: 1.0)

struct InstructionView: View {
    
    @Binding var currentGameState: GameState
    
    var gameTitle: String = MainScreenProperties.gameTitle
    
    var gameInstructions: [Instruction] = MainScreenProperties.gameInstructions
    
    var body: some View {
        ZStack {
            Image("menu_background_parket")
                .resizable()
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 16.0) {

                Image("\(self.gameTitle)")
                    .resizable()
                    .frame(width: 120, height: 80)
                
                Spacer()

                ForEach(self.gameInstructions, id: \.icon) { instruction in
                    GroupBox() {
                        HStack {
                            Image(instruction.icon)
                                .resizable()
                                .frame(width: 35, height: 45)
                            Text((instruction.description))
                                .font(.headline)
                                .foregroundStyle(.black)
                            Spacer()
                        }
                    }
                    .shadow(radius: 15)
                    .groupBoxStyle(CustomGroupBoxStyle(color: myColor))
                }
                
                Spacer()
                
                Button {
                        withAnimation { self.backToMainScreen() }
                } label: {
                    Image("play_button1")
                }
                .padding(.bottom, 14.5)
            }
            .padding()
        .statusBar(hidden: true)
        }
    }
    
    private func backToMainScreen() {
        self.currentGameState = .menuScreen
    }
}


#Preview {
    InstructionView(currentGameState: .constant(GameState.instruction))
}
