//
//  ArticleScreen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import SwiftUI

struct ArticleScreen: Screen {
    @StateObject private var viewModel: ArticleViewModel

    // MARK: - Initializer
    init(fullSlug: String, storyFetcher: StoryFetcher) {
        _viewModel = StateObject(wrappedValue: ArticleViewModel(fullSlug: fullSlug, storyFetcher: storyFetcher))
    }

    // MARK: - Screen Title
    var title: String? {
        viewModel.articleBlock?.title
    }

    // MARK: - Loading and Error State
    var isLoading: Bool {
        viewModel.isLoading
    }

    var errorMessage: String? {
        viewModel.errorMessage
    }

    // MARK: - Screen Content
    var bodyContent: some View {
        ScrollView {
            if let articleBlock = viewModel.articleBlock {
                ArticleBlockView(block: articleBlock)
            } else if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchArticle()
        }
    }
}
