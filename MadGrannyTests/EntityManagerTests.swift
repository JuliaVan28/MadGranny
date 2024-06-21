//
//  EntityManagerTests.swift
//  MadGrannyTests
//
//  Created by Yuliia on 20/06/24.
//

import XCTest
import SpriteKit
import GameplayKit
@testable import MadGranny

final class EntityManagerTests: XCTestCase {
    
    var scene: SKScene!
    var entityManager: EntityManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // Initialize SKScene and EntityManager before each test
        scene = SKScene(size: CGSize(width: UIScreen.main.bounds.size.width
                                     , height: UIScreen.main.bounds.size.width))
        entityManager = EntityManager(scene: scene)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        scene = nil
        entityManager = nil
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testAddEntity() {
        // Create a dummy entity
        let grannyEntity = Granny(entityManager: entityManager)
        
        // Add entity to EntityManager
        entityManager.add(grannyEntity)
        
        // Verify the entity is added
        XCTAssertTrue(entityManager.entities.contains(grannyEntity), "Entity should be added to the entities set")
        XCTAssertEqual(scene.children.count, 1, "Entity's sprite node should be added to the scene")
    }
    
    func testRemoveEntity() {
        // Create a dummy entity
        let grannyEntity = Granny(entityManager: entityManager)
        
        // Add entity to EntityManager
        entityManager.add(grannyEntity)
        entityManager.remove(grannyEntity)
        
        // Verify the entity is removed
        XCTAssertFalse(entityManager.entities.contains(grannyEntity), "Entity should be removed from the entities set")
        XCTAssertTrue(entityManager.toRemove.contains(grannyEntity), "Entity should be added to the toRemove set")
        XCTAssertEqual(scene.children.count, 0, "Entity's sprite node should be removed from the scene")
    }
    
    func testUpdate() {
        // Create and add a dummy entity with a MoveComponent
        let grannyEntity = Granny(entityManager: entityManager)
        
        entityManager.add(grannyEntity)
        
        // Call update
        entityManager.update(1.0)
        
        // Verify that the component systems are updated (indirectly, we can check if the entity is still in the system)
        XCTAssertTrue(entityManager.entities.contains(grannyEntity), "Entity should still be in the entities set after update")
    }
    
    func testPauseEntities() {
            // Create and add a dummy Granny entity
        let grannyEntity = Granny(entityManager: entityManager)

            entityManager.add(grannyEntity)
            
            // Call pauseEntities
            entityManager.pauseEntities()
            
            // Verify the granny's position is saved and it's removed from the scene
            XCTAssertEqual(entityManager.grannyPositions.count, 1, "Granny's position should be saved")
            XCTAssertFalse(entityManager.entities.contains(grannyEntity), "Granny entity should be removed from entities set")
            XCTAssertEqual(scene.children.count, 0, "Granny's sprite node should be removed from the scene")
            XCTAssertTrue(entityManager.isPaused, "EntityManager should be paused")
        }
    
    func testResumeEntities() {
            // Create and add a dummy Granny entity and a child entity
            let grannyEntity = Granny(entityManager: entityManager)
        entityManager.grannyPositions.append(grannyEntity.component(ofType: SpriteComponent.self)!.node.position)
            
            let childEntity = Child(entityManager: entityManager)
            entityManager.childPosition = childEntity.component(ofType: SpriteComponent.self)!.node.position
            
            // Call resumeEntities
            entityManager.resumeGrannies()
            
            // Verify the entities are respawned and added back to the scene
            XCTAssertEqual(scene.children.count, 2, "Both Granny and Child sprite nodes should be added back to the scene")
            XCTAssertFalse(entityManager.isPaused, "EntityManager should not be paused")
        }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
