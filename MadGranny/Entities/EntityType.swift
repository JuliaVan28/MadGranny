//
//  EntityType.swift
//  MadGranny
//
//  Created by Yuliia on 10/12/23.
//

import Foundation
/**
 * # EntityType
 * Defines the different enities.
 * Used for searching specific entities in entities = Set<GKEntity>() of EntityManager
 */
enum EntityType {
    case child
    case granny
    case candy
    case carrot
    case table
    case plant
    case chair
    case unknown
}
