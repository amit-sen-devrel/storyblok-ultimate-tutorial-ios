//
//  Asset.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


/// Represents a media asset (e.g., image) associated with an article or block.
struct Asset: Codable {
    /// The unique identifier for the asset.
    let id: Int
    
    /// The URL of the asset file.
    let filename: String
}
