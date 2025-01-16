//
//  PopularArticlesBlock.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 15.01.25.
//


struct PopularArticlesBlock: Codable {
    let _uid: String           // Unique identifier for the block
    let headline: String       // Headline for the articles section
    var articles: [String] // Original array of ArticleReference
    var resolvedArticles: [ArticleCard]? = nil // Resolved articles for rendering (optional)
    let component: String      // Identifies the block type as "popular-articles"
}

struct ArticleReference: Codable {
    let uuid: String
}

extension PopularArticlesBlock {
    mutating func resolveRelations(using resolver: StoryRelationResolver) {
        resolvedArticles = articles.compactMap { uuid in
            // Resolve the UUID to its full content dictionary
            guard let resolvedContent = resolver.resolveContentValue(.string(uuid)).toDictionary() else {
                return nil
            }
            
            // Map the resolved content to an ArticleCard object
            return ArticleCard(
                uuid: uuid,
                title: resolvedContent["title"]?.toString() ?? "",
                teaser: resolvedContent["teaser"]?.toString() ?? "",
                image: resolvedContent["image"]?.toAsset(),
                fullSlug: resolvedContent["full_slug"]?.toString() ?? ""
            )
        }
    }
}
