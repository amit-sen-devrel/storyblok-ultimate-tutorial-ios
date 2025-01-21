//
//  SingleArticleScreen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import SwiftUI

/// A screen that displays a single article based on the provided slug.
struct SingleArticleScreen: Screen {
    
    // MARK: - Properties
    
    /// The ViewModel responsible for fetching and managing the article data.
    @StateObject private var viewModel: SingleArticleViewModel
    
    /// The navigation path for dynamic navigation handling.
    var navigationPath: Binding<NavigationPath> // Conform to the `Screen` protocol

    // MARK: - Initializer
    
    /**
     Initializes the `SingleArticleScreen` with the required slug, story fetcher, and navigation path.
     
     - Parameters:
        - fullSlug: The slug identifying the article to display.
        - storyFetcher: The `StoryFetcher` instance used to retrieve the article data.
        - navigationPath: A binding to the navigation path for managing navigation state.
     */
    init(fullSlug: String, storyFetcher: StoryFetcher, navigationPath: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue: SingleArticleViewModel(fullSlug: fullSlug, storyFetcher: storyFetcher))
        self.navigationPath = navigationPath
    }

    // MARK: - Screen Title
    
    /// The title of the screen, derived from the article's title.
    var title: String? {
        viewModel.articleBlock?.title
    }

    // MARK: - Loading and Error State
    
    /// Indicates whether the screen is in a loading state.
    var isLoading: Bool {
        viewModel.isLoading
    }

    /// Error message to display if an error occurs.
    var errorMessage: String? {
        viewModel.errorMessage
    }

    // MARK: - Screen Content
    
    /// The main content of the screen.
    var bodyContent: some View {
        ScrollView {
            // Display the article content if available
            if let articleBlock = viewModel.articleBlock {
                ArticleBlockView(block: articleBlock)
            }
        }
        .navigationBarTitleDisplayMode(.inline) // Use an inline navigation bar title
        .toolbar {
            // Display the title in the toolbar
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(title ?? "Article")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .onAppear {
            // Fetch the article data when the screen appears
            viewModel.fetchArticle()
        }
    }
}
