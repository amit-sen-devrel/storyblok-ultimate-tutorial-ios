//
//  Block.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 15.01.25.
//


/// A base model representing a generic block in the Storyblok content structure.
struct Block: Codable {
    /// A unique identifier for the block.
    let _uid: String
    
    /// The type of the block, represented as a component string.
    let component: String
}
