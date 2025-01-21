//
//  HomeScreen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//

import SwiftUI

/// The HomeScreen displays dynamic content blocks fetched from the Storyblok API.
/// It uses a `HomeViewModel` to manage data fetching and state, and supports navigation to detailed screens.
struct HomeScreen: Screen {
    @StateObject private var viewModel: HomeViewModel
    var navigationPath: Binding<NavigationPath>
    
    // MARK: - Initializer
    
    /**
     Initializes the HomeScreen with a ViewModel and a navigation path binding.
     
     - Parameters:
       - viewModel: The `HomeViewModel` responsible for managing the screen's state and logic.
       - navigationPath: A binding to the navigation path for dynamic navigation.
     */
    init(viewModel: HomeViewModel, navigationPath: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.navigationPath = navigationPath
    }
    
    // MARK: - Screen Title
    
    /// The title displayed in the navigation bar.
    var title: String? {
        "Home"
    }
    
    // MARK: - Loading and Error State
    
    /// Indicates whether the screen is currently loading data.
    var isLoading: Bool {
        viewModel.isLoading
    }
    
    /// Holds any error message if the data fetch fails.
    var errorMessage: String? {
        viewModel.errorMessage
    }
    
    // MARK: - Screen Content
    
    /**
     The main content of the screen, displaying a scrollable list of dynamic blocks.
     
     - Includes support for:
       - `HeroBlockView` for hero sections.
       - `ArticlesBlockView` for article lists.
     - Dynamically navigates to a `SingleArticleScreen` when an article is selected.
     */
    var bodyContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.blocks.indices, id: \.self) { index in
                    if let heroBlock = viewModel.blocks[index] as? HeroBlock {
                        // Render a hero block
                        HeroBlockView(block: heroBlock)
                    } else if let popularArticlesBlock = viewModel.blocks[index] as? PopularArticlesBlock {
                        // Render a popular articles block with navigation
                        ArticlesBlockView(block: popularArticlesBlock) { fullSlug in
                            // Append the selected article slug to the navigation path
                            navigationPath.wrappedValue.append(fullSlug)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationDestination(for: String.self) { fullSlug in
            // Navigate to a SingleArticleScreen for the selected article
            SingleArticleScreen(
                fullSlug: fullSlug,
                storyFetcher: viewModel.storyFetcher,
                navigationPath: navigationPath
            )
        }
        .onAppear {
            // Fetch the home story when the view appears
            viewModel.fetchHomeStory()
        }
    }
}
