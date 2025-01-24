//
//  PageScreen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 23.01.25.
//


import SwiftUI

/// A dynamic screen that fetches and displays a story based on the provided slug.
struct PageScreen: Screen {
    @StateObject private var viewModel: PageViewModel
    var navigationPath: Binding<NavigationPath>
    
    // MARK: - Initializer
    init(viewModel: PageViewModel, navigationPath: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.navigationPath = navigationPath
    }
    
    // MARK: - Screen Attributes
    
    /// The title displayed in the navigation bar.
    var title: String? {
        viewModel.title
    }
    
    /// Indicates whether the screen is currently loading data.
    var isLoading: Bool {
        viewModel.isLoading
    }
    
    /// Holds any error message if the data fetch fails.
    var errorMessage: String? {
        viewModel.errorMessage
    }
    
    // MARK: - Body
    var bodyContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.blockViews.indices, id: \.self) { index in
                    // Directly use the AnyView without conditional binding
                    viewModel.blockViews[index]
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchStory()
        }
        .navigationDestination(for: NavigationDestination.self) { destination in
            switch destination {
            case .singleArticle(let slug):
                PageScreen(
                    viewModel: PageViewModel(
                        storyFetcher: viewModel.storyFetcher,
                        slug: slug
                    ),
                    navigationPath: navigationPath
                )
            }
        }
    }
}
