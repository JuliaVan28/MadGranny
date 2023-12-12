
//  AnimatedImageView.swift
//  MadGranny
//
//  Created by Emanuela Imparato on 12/12/23.


import SwiftUI

struct AnimatedImageView: View {
    let frames = [
        Image("play_button1"),
        Image("play_button2"),
        Image("play_button3"),
        Image("play_button4")
    ]

    @State private var currentFrameIndex = 0

    var body: some View {
        
        HStack{
            frames[currentFrameIndex]
                .onTapGesture {
                    withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                        currentFrameIndex = (currentFrameIndex + 1) % frames.count

                    }
                }
            
        }
        .padding(.top, 650)
    }
}

#Preview {
    AnimatedImageView()
}
