//
//  PopularArticlesBlockView.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//

import SwiftUI

struct PopularArticlesBlockView: View {
    let block: PopularArticlesBlock
    let onArticleSelected: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(block.headline)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)

            ForEach(block.resolvedArticles ?? [], id: \.uuid) { article in
                ArticleCardView(article: article) { fullSlug in
                    onArticleSelected(fullSlug)
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}
