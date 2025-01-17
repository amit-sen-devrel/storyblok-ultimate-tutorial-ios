//
//  SingleArticleScreen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import SwiftUI

struct SingleArticleScreen: Screen {
    
    @StateObject private var viewModel: SingleArticleViewModel
    var navigationPath: Binding<NavigationPath> // Conform to the protocol

    // MARK: - Initializer
    init(fullSlug: String, storyFetcher: StoryFetcher, navigationPath: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue: SingleArticleViewModel(fullSlug: fullSlug, storyFetcher: storyFetcher))
        self.navigationPath = navigationPath
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
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(title ?? "Article")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .onAppear {
            viewModel.fetchArticle()
        }
    }
}
