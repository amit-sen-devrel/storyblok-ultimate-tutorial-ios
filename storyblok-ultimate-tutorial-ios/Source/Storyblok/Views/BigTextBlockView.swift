//
//  BigTextBlockView.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 24.01.25.
//


import SwiftUI

/// A view for rendering the "big_text" block with rich text content.
struct BigTextBlockView: ViewComponent {
    let block: BigTextBlock

    var bodyContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let textNodes = block.text {
                RichTextView(nodes: textNodes) // Render rich text content using RichTextView
            } else {
                Text("No content available")
                    .foregroundColor(.gray)
            }
        }
    }
}
