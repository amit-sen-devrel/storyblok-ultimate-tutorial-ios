//
//  ArticlesScreen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//

import SwiftUI

/// A screen displaying a list of articles.
///
/// This screen fetches and displays a list of articles from the API. Each article is shown as a card,
/// and tapping on a card navigates to the `SingleArticleScreen` for the selected article.
struct ArticlesScreen: Screen {
    // MARK: - Properties
    
    /// The view model managing the state and data for the screen.
    @StateObject private var viewModel: ArticlesViewModel
    
    /// The navigation path for handling dynamic navigation.
    var navigationPath: Binding<NavigationPath>

    // MARK: - Initializer
    
    /// Initializes the screen with a view model and navigation path.
    ///
    /// - Parameters:
    ///   - viewModel: The `ArticlesViewModel` instance managing the articles data.
    ///   - navigationPath: The binding to a `NavigationPath` for dynamic navigation.
    init(viewModel: ArticlesViewModel, navigationPath: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.navigationPath = navigationPath
    }

    // MARK: - Screen Title
    
    /// The title displayed in the navigation bar.
    var title: String? {
        "Articles"
    }

    // MARK: - Loading and Error State
    
    /// Indicates whether the screen is currently loading data.
    var isLoading: Bool {
        viewModel.isLoading
    }

    /// Holds any error message to display if data fetching fails.
    var errorMessage: String? {
        viewModel.errorMessage
    }

    // MARK: - Screen Content
    
    /// The main content of the screen.
    var bodyContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Iterate through the list of article cards and display them
                ForEach(viewModel.articleCards, id: \.uuid) { articleCard in
                    ArticleCardView(article: articleCard) { fullSlug in
                        // Navigate to the SingleArticleScreen with the selected article slug
                        navigationPath.wrappedValue.append(fullSlug)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationDestination(for: String.self) { fullSlug in
            // Define the destination for dynamic navigation
            SingleArticleScreen(
                fullSlug: fullSlug,
                storyFetcher: viewModel.storyFetcher,
                navigationPath: navigationPath
            )
        }
        .onAppear {
            // Fetch all articles when the screen appears
            viewModel.fetchAllArticles()
        }
    }
}
