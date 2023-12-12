//
//  GameLogic.swift
//  MadGranny
//
//  Created by Yuliia on 07/12/23.
//

import Foundation

class GameLogic: ObservableObject {
    
    // Single instance of the class
    static let shared: GameLogic = GameLogic()
    
    //MARK: - Properties
    
    // Keep tracks of the duration of the current session in number of seconds
    @Published var timerDuration: TimeInterval = 0
    
    // Game Over Boolean
    @Published var isGameOver: Bool = false
    
    // Keeps track of the current score of the player
    @Published var currentScore: Int = 0
    
    //MARK: - Functions
    
    // Function responsible to set up the game before it starts.
    func setUpGame() {
        self.currentScore = 0
        self.timerDuration = 0
        print("setUpGame is called")
        self.isGameOver = false
    }

    
    func restartGame() {
        self.setUpGame()
    }
    
    func finishTheGame() {
        if self.isGameOver == false {
            self.isGameOver = true
            print("Game over was false now true")
        }
        print("Game over is true")
    }
    
    //Increment Timer of the game session
    func increaseSessionTime(by timeIncrement: TimeInterval) {
        self.timerDuration = self.timerDuration + timeIncrement
    }
    
    // Increases the score by a certain amount of points
    func score(points: Int) {
        self.currentScore = self.currentScore + points
    }
}
