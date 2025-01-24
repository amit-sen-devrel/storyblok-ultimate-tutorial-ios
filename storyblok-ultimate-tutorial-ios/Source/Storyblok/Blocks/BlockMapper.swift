//
//  BlockMapper.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//

import Foundation
import SwiftUI

final class BlockMapper {
    /**
     Maps a `ContentValue` to its corresponding block view using `BlockRegistry`.
     
     - Parameters:
     - contentValue: The content value representing the block.
     - resolver: An optional `StoryRelationResolver` to resolve relations.
     - Returns: An `AnyView` for the block or `nil` if mapping fails.
     */
    static func map<T: RelationResolvableBlock>(
        contentValue: ContentValue,
        as type: T.Type,
        resolver: StoryRelationResolver? = nil
    ) -> AnyView? {
        guard case let .dictionary(value) = contentValue,
              let data = try? JSONEncoder().encode(value),
              var block = try? JSONDecoder().decode(type, from: data) else {
            return nil
        }
        
        // Resolve relations if the block conforms to RelationResolvableBlock
        resolver.map { block.resolveRelations(using: $0) }
        
        // Use BlockRegistry to fetch the view directly
        guard let view = BlockRegistry.shared.getBlockView(for: block.component, using: block) else {
            print("No view registered for component: \(block.component)")
            return nil
        }
        
        return view
    }
    
    static func mapSingleArticleBlock(storyResponse: StoryResponse) -> AnyView? {
        let articleBlock = ArticleBlock(
            _uid: storyResponse.story.content.fields["_uid"]?.toString() ?? "",
            component: storyResponse.story.content.fields["component"]?.toString() ?? "",
            title: storyResponse.story.content.fields["title"]?.toString() ?? "",
            teaser: storyResponse.story.content.fields["teaser"]?.toString() ?? "",
            image: storyResponse.story.content.fields["image"]?.toAsset(),
            richContent: storyResponse.story.content.fields["content"]?.toRichText()
        )
        
        return AnyView(ArticleBlockView(block: articleBlock))
    }
}
