//
//  ArticleBlockView.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import SwiftUI

struct ArticleBlockView: View {
    let block: ArticleBlock

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Display the image if available
            if let imageURL = block.image?.filename, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                    case .failure:
                        Color.gray.frame(height: 200)
                    @unknown default:
                        Color.gray.frame(height: 200)
                    }
                }
            }

            // Display the teaser
            Text(block.teaser)
                .font(.subheadline)
                .foregroundColor(.gray)

            // Use RichTextView to display the rich text content
            if let richContent = block.richContent {
                RichTextView(nodes: richContent)
            }
        }
        .padding()
    }
}
