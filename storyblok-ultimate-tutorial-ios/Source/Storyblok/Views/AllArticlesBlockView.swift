//
//  AllArticlesBlockView.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//


import SwiftUI

struct AllArticlesBlockView: ViewComponent {
    let block: AllArticlesBlock

    var bodyContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(block.headline)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
        }
        .padding(.vertical)
    }
}
