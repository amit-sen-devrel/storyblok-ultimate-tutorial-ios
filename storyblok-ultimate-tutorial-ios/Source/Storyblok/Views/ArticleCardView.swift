//
//  ArticleCardView.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import SwiftUI

struct ArticleCardView: ViewComponent {
    let article: ArticleCard
    let onTap: (String) -> Void

    var bodyContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Display the image if available
            if let imageURL = article.image?.filename, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 150)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .cornerRadius(8)
                    case .failure:
                        Color.gray
                            .frame(height: 150)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(8)
                    @unknown default:
                        Color.gray
                            .frame(height: 150)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(8)
                    }
                }
            }

            // Display the title
            Text(article.title)
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            // Display the teaser
            Text(article.teaser)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 4)
        .onTapGesture {
            onTap(article.fullSlug)
        }
    }
}

