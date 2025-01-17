//
//  ArticleResponse.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


struct ArticleResponse: Codable {
    let uuid: String
    let fullSlug: String
    let content: ArticleCard

    private enum CodingKeys: String, CodingKey {
        case uuid, content
        case fullSlug = "slug"
    }
}
