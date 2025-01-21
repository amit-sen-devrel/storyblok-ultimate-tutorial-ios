//
//  ArticlesBlockView.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//

import SwiftUI

/// A view that displays a block of articles, including a headline and a list of article cards.
///
/// This view is designed to render a block of articles using the `PopularArticlesBlock` model. It displays
/// a headline at the top, followed by a list of article cards. Each card can trigger a callback when selected.
struct ArticlesBlockView: ViewComponent {
    /// The block of popular articles to display.
    let block: PopularArticlesBlock
    
    /// Callback for handling article selection events.
    /// - Parameter fullSlug: The slug of the selected article.
    let onArticleSelected: (String) -> Void

    /// The main content of the articles block.
    var bodyContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Headline
            // Display the headline for the articles block
            Text(block.headline)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)

            // MARK: - Articles List
            // Iterate over the resolved articles and render each as a card
            ForEach(block.resolvedArticles ?? [], id: \.uuid) { article in
                ArticleCardView(article: article) { fullSlug in
                    // Trigger the onArticleSelected callback with the selected article's fullSlug
                    onArticleSelected(fullSlug)
                }
                .padding(.horizontal) // Add padding to each card
            }
        }
        .padding(.vertical) // Add vertical padding around the entire block
    }
}
