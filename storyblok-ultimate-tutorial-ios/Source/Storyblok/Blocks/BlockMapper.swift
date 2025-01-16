//
//  BlockMapper.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//

import Foundation

final class BlockMapper {
    static func map(contentValue: ContentValue, resolver: StoryRelationResolver?) -> Decodable? {
        if case let .dictionary(value) = contentValue {
            guard let data = try? JSONEncoder().encode(value) else {
                return nil
            }
            
            // Handle specific block types
            if let component = value["component"]?.toString() {
                switch component {
                case "hero":
                    return try? JSONDecoder().decode(HeroBlock.self, from: data)
                case "popular-articles":
                    var popularArticles = try? JSONDecoder().decode(PopularArticlesBlock.self, from: data)
                    if let resolver {
                        popularArticles?.resolveRelations(using: resolver)
                    }
                    return popularArticles
                default:
                    print("Unhandled block type: \(component)")
                    return nil
                }
            }
        }
        return nil
    }
}
