//
//  ArticleCard.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


struct ArticleCard: Codable {
    let uuid: String
    let title: String
    let teaser: String
    let image: Asset?
    let fullSlug: String
    
    private enum CodingKeys: String, CodingKey {
        case uuid, fullSlug = "slug"
        case title, teaser, image
    }
}
