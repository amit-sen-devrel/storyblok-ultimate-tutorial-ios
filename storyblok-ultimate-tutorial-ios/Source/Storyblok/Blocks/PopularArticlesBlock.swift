//
//  PopularArticlesBlock.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 15.01.25.
//


/// A model representing a block that contains popular articles.
struct PopularArticlesBlock: RelationResolvableBlock {
    /// Unique identifier for the block.
    let _uid: String
    
    /// The headline or title for the articles section.
    let headline: String
    
    /// An array of UUIDs representing the referenced articles.
    var articles: [String]
    
    /// An array of resolved articles, used for rendering.
    /// This is optional and is populated after resolving relations.
    var resolvedArticles: [ArticleCard]? = nil
    
    /// Identifies the block type, expected to be "popular-articles".
    let component: String
    
    /**
     Resolves UUID references in the `articles` array to their full content data.
     
     - Parameter resolver: The `StoryRelationResolver` used to fetch and resolve relations.
     */
    mutating func resolveRelations(using resolver: StoryRelationResolver) {
        // Transform each UUID into its full resolved article content.
        resolvedArticles = articles.compactMap { uuid in
            // Resolve the UUID to its associated content dictionary.
            guard let resolvedContent = resolver.resolveContentValue(.string(uuid)).toDictionary() else {
                return nil
            }
            
            // Map the resolved content to an ArticleCard object.
            return ArticleCard(
                uuid: uuid,
                title: resolvedContent["title"]?.toString() ?? "", // Extract title from resolved content.
                teaser: resolvedContent["teaser"]?.toString() ?? "", // Extract teaser.
                image: resolvedContent["image"]?.toAsset(), // Extract image as Asset.
                fullSlug: resolvedContent["slug"]?.toString() ?? "" // Extract full slug.
            )
        }
    }
}


/// A model representing an article reference by its UUID.
struct ArticleReference: Codable {
    /// The UUID of the referenced article.
    let uuid: String
}
