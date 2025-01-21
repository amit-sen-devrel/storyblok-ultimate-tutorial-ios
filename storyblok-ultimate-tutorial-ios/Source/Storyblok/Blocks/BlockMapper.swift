//
//  BlockMapper.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//

import Foundation

/// A utility class responsible for mapping content values to specific block types.
final class BlockMapper {
    
    /**
     Maps a `ContentValue` to a specific block type (e.g., `HeroBlock`, `PopularArticlesBlock`).
     
     - Parameter contentValue: The `ContentValue` representing the block's data.
     - Parameter resolver: An optional `StoryRelationResolver` for resolving UUID relations.
     - Returns: A decoded block conforming to `Decodable` or `nil` if the mapping fails.
     
     ### Usage
     ```swift
     let block: Decodable? = BlockMapper.map(contentValue: someContentValue, resolver: someResolver)
     if let heroBlock = block as? HeroBlock {
         // Use the hero block
     }
     ```
     */
    static func map(contentValue: ContentValue, resolver: StoryRelationResolver?) -> Decodable? {
        // Ensure the contentValue is a dictionary.
        if case let .dictionary(value) = contentValue {
            // Encode the dictionary to JSON data.
            guard let data = try? JSONEncoder().encode(value) else {
                return nil
            }
            
            // Extract the "component" field to identify the block type.
            if let component = value["component"]?.toString() {
                switch component {
                case "hero":
                    // Decode a HeroBlock.
                    return try? JSONDecoder().decode(HeroBlock.self, from: data)
                case "popular-articles", "all-articles":
                    // Decode a PopularArticlesBlock and resolve relations if a resolver is provided.
                    var articlesBlock = try? JSONDecoder().decode(PopularArticlesBlock.self, from: data)
                    if let resolver {
                        articlesBlock?.resolveRelations(using: resolver)
                    }
                    return articlesBlock
                case "section":
                    // Decode a SectionBlock.
                    return try? JSONDecoder().decode(SectionBlock.self, from: data)
                default:
                    // Print a message for unhandled block types.
                    print("Unhandled block type: \(component)")
                    return nil
                }
            }
        }
        return nil
    }
}
