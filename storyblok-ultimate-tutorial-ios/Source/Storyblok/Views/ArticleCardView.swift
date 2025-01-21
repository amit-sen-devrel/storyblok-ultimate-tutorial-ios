//
//  ArticleCardView.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import SwiftUI

/// A view to display an article card, including its image, title, and teaser.
///
/// This view is designed to provide a tappable card-style representation of an article.
/// It uses a callback (`onTap`) to handle user interactions.
struct ArticleCardView: ViewComponent {
    /// The article data to display.
    let article: ArticleCard
    
    /// Callback for handling tap events on the card.
    let onTap: (String) -> Void

    /// The main content of the article card.
    var bodyContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            // MARK: - Image Display
            // Display the article image if available
            if let imageURL = article.image?.filename, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        // Show a progress indicator while the image loads
                        ProgressView()
                            .frame(height: 150)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        // Display the successfully loaded image
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .cornerRadius(8)
                    case .failure:
                        // Display a placeholder for failed image loads
                        Color.gray
                            .frame(height: 150)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(8)
                    @unknown default:
                        // Handle unexpected states
                        Color.gray
                            .frame(height: 150)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(8)
                    }
                }
            }

            // MARK: - Title Display
            // Display the article title with bold styling and line limits
            Text(article.title)
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            // MARK: - Teaser Display
            // Display the article teaser text with subtle styling
            Text(article.teaser)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Color(.systemGray6)) // Light gray background for the card
        .cornerRadius(12) // Rounded corners for the card
        .shadow(radius: 4) // Subtle shadow for a card-like effect
        .onTapGesture {
            // Trigger the onTap callback with the article's fullSlug
            onTap(article.fullSlug)
        }
    }
}
