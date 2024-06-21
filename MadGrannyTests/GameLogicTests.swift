//
//  GameLogicTests.swift
//  MadGrannyTests
//
//  Created by Yuliia on 20/06/24.
//

import XCTest
@testable import MadGranny


final class GameLogicTests: XCTestCase {
    
    var gameLogic: GameLogic!


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        gameLogic = GameLogic.shared

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        gameLogic = nil

    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testSetUpGame() {
           // Test setUpGame function
           gameLogic.setUpGame()
           
           XCTAssertEqual(gameLogic.currentScore, 0, "Current score should be reset to 0")
           XCTAssertEqual(gameLogic.timerDuration, 0, "Timer duration should be reset to 0")
           XCTAssertFalse(gameLogic.isGameOver, "Game should not be over after setup")
       }
    
    func testRestartGame() {
            // Test restartGame function
            gameLogic.currentScore = 100
            gameLogic.isGameOver = true
            
            gameLogic.restartGame()
            
            XCTAssertEqual(gameLogic.currentScore, 0, "Current score should be reset to 0")
            XCTAssertEqual(gameLogic.timerDuration, 0, "Timer duration should be reset to 0")
            XCTAssertFalse(gameLogic.isGameOver, "Game should not be over after restart")
        }
    
    func testFinishTheGame() {
           // Test finishTheGame function
           gameLogic.isGameOver = false
           
           gameLogic.finishTheGame()
           
           XCTAssertTrue(gameLogic.isGameOver, "Game should be over after finishing the game")
       }
    
    func testScore() {
            // Test score function
            gameLogic.currentScore = 50
            
            gameLogic.score(points: 10)
            
            XCTAssertEqual(gameLogic.currentScore, 60, "Current score should be increased by 10 points")
        }
    
    func testStopTimer() {
            // Test stopTimer function
            gameLogic.startTimer()
            gameLogic.stopTimer()
            
            XCTAssertTrue(gameLogic.isPaused, "Timer should be paused after stopping")
        }

        func testStartTimer() {
            // Test startTimer function
            gameLogic.stopTimer()
            gameLogic.startTimer()
            
            XCTAssertFalse(gameLogic.isPaused, "Timer should not be paused after starting")
        }
    
    func testCancelTimer() {
            // Test cancelTimer function
            gameLogic.timerDuration = 100
            gameLogic.cancelTimer()
            
            XCTAssertEqual(gameLogic.timerDuration, 0, "Timer duration should be reset to 0")
            XCTAssertTrue(gameLogic.isPaused, "Timer should be paused after cancelling")
        }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
