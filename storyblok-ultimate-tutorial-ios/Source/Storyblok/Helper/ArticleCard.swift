//
//  ArticleCard.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


/// Represents a summarized view of an article for display in lists or previews.
struct ArticleCard: Codable {
    /// The unique identifier of the article.
    let uuid: String
    
    /// The title of the article.
    let title: String
    
    /// A short description or teaser for the article.
    let teaser: String
    
    /// The featured image associated with the article.
    let image: Asset?
    
    /// The full slug (path) of the article, used for navigation or API requests.
    let fullSlug: String
    
    /// Maps coding keys to match the JSON structure returned by the API.
    private enum CodingKeys: String, CodingKey {
        case uuid
        case fullSlug = "slug" // Maps the API "slug" field to "fullSlug".
        case title
        case teaser
        case image
    }
}
