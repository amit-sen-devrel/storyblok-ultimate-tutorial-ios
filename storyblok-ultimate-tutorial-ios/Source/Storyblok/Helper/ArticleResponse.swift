//
//  ArticleResponse.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


/// Represents the full API response for a single article.
struct ArticleResponse: Codable {
    /// The unique identifier of the article.
    let uuid: String
    
    /// The full slug (path) of the article, used for navigation or API requests.
    let fullSlug: String
    
    /// The content of the article, represented as an `ArticleCard`.
    let content: ArticleCard

    /// Maps coding keys to match the JSON structure returned by the API.
    private enum CodingKeys: String, CodingKey {
        case uuid
        case content
        case fullSlug = "slug" // Maps the API "slug" field to "fullSlug".
    }
}
