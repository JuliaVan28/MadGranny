//
//  GamePointsView.swift
//  MadGranny
//
//  Created by Vanda Savkina on 08/12/23.
//

import SwiftUI

/**
 * # GameScoreView
 * Custom UI to present how many points the player has scored.
 *
 * Customize it to match the visual identity of your game.
 */

struct GamePointsView: View {
    @Binding var score: Int
    
    var body: some View {
        
        HStack {
            Image("dish")
                .resizable()
                .frame(width: 130, height: 80)
           // Text("\(score)")
             //   .font(.headline)
        }
        .frame(minWidth: 60)
        //.padding(24)
       // .foregroundColor(.white)
       // .background(Color(UIColor.systemGray))
       // .cornerRadius(10)
    }
}

#Preview {
    GamePointsView(score: .constant(100))
        .previewLayout(.fixed(width: 300, height: 100))
}
