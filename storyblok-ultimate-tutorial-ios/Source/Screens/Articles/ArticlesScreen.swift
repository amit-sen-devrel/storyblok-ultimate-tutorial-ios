//
//  ArticlesScreen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//


import SwiftUI

struct ArticlesScreen: Screen {
    @StateObject private var viewModel: ArticlesViewModel
    var navigationPath: Binding<NavigationPath>

    // MARK: - Initializer
    init(viewModel: ArticlesViewModel, navigationPath: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.navigationPath = navigationPath
    }

    // MARK: - Screen Title
    var title: String? {
        "Articles"
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
            VStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.articleCards, id: \.uuid) { articleCard in
                    ArticleCardView(article: articleCard) { fullSlug in
                        navigationPath.wrappedValue.append(fullSlug)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationDestination(for: String.self) { fullSlug in
            SingleArticleScreen(
                fullSlug: fullSlug,
                storyFetcher: viewModel.storyFetcher,
                navigationPath: navigationPath
            )
        }
        .onAppear {
            viewModel.fetchAllArticles()
        }
    }
}
