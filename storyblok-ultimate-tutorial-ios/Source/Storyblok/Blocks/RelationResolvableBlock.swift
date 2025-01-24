//
//  RelationResolvableBlock.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 24.01.25.
//


import Foundation

/// Protocol for blocks that can resolve relations
protocol RelationResolvableBlock: Decodable {
    /// Unique identifier for the block
    var _uid: String { get }
    /// Component type for the block
    var component: String { get }
    
    /// Resolves relations using a resolver
    mutating func resolveRelations(using resolver: StoryRelationResolver)
}

// Provide a default implementation for `resolveRelations`
extension RelationResolvableBlock {
    mutating func resolveRelations(using resolver: StoryRelationResolver) {
        // Default: No relations to resolve
    }
}

