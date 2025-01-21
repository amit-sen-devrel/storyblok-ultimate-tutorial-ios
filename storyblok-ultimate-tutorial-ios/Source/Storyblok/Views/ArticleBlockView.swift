//
//  ArticleBlockView.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import SwiftUI

/// A view to display the content of an `ArticleBlock`.
///
/// This view handles the display of an article block, including its image, teaser text,
/// and rich text content parsed from `RichTextNode`.
struct ArticleBlockView: ViewComponent {
    /// The article block to render.
    let block: ArticleBlock

    /// The main body content of the view.
    var bodyContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Image Display
            // Display the article image if available
            if let imageURL = block.image?.filename, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        // Show a progress indicator while the image loads
                        ProgressView()
                            .frame(height: 200)
                    case .success(let image):
                        // Display the loaded image
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                    case .failure:
                        // Display a placeholder for failed image loads
                        Color.gray.frame(height: 200)
                    @unknown default:
                        // Handle unexpected states
                        Color.gray.frame(height: 200)
                    }
                }
            }

            // MARK: - Teaser Text
            // Display the teaser text with styling
            Text(block.teaser)
                .font(.subheadline)
                .foregroundColor(.gray)

            // MARK: - Rich Text Content
            // Render rich text content if available using RichTextView
            if let richContent = block.richContent {
                RichTextView(nodes: richContent)
            }
        }
        .padding() // Add padding around the content
    }
}
