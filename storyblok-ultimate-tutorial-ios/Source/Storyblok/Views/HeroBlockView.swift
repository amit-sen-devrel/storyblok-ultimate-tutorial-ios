//
//  HeroBlockView.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//

import SwiftUI

struct HeroBlockView: ViewComponent {
    let block: HeroBlock

    var bodyContent: some View {
        ZStack(alignment: .bottom) {
            // Display the background image if available
            if let imageURL = block.backgroundImage?.filename, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    case .failure:
                        Color.gray
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                    @unknown default:
                        Color.gray
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                    }
                }
            }

            // Overlay headline and subheadline
            VStack(alignment: .center, spacing: 4) {
                Text(block.headline)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 5)

                if let subheadline = block.subheadline {
                    Text(subheadline)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}


