//
//  HeroBlock.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 15.01.25.
//


/// A model representing a Hero block, typically used for large banners or header sections.
struct HeroBlock: Codable {
    /// A unique identifier for the hero block.
    let _uid: String
    
    /// The layout style for the hero block (e.g., constrained, full-width).
    let layout: String
    
    /// The headline text displayed prominently in the hero block.
    let headline: String
    
    /// An optional subheadline text for additional context or description.
    let subheadline: String?
    
    /// An optional background image for the hero block.
    let backgroundImage: Asset?
    
    /// The type of block, fixed as `hero` for this model.
    let component: String
    
    // Coding keys to map JSON keys to Swift property names.
    private enum CodingKeys: String, CodingKey {
        case _uid, layout, headline, subheadline, component
        case backgroundImage = "background_image"
    }
}
