//
//  HomeScreen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//

import SwiftUI

struct HomeScreen: Screen {
    @StateObject private var viewModel: HomeViewModel
    var navigationPath: Binding<NavigationPath>
    
    // MARK: - Initializer
    init(viewModel: HomeViewModel, navigationPath: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.navigationPath = navigationPath
    }
    
    // MARK: - Screen Title
    var title: String? {
        "Home"
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
                ForEach(viewModel.blocks.indices, id: \.self) { index in
                    if let heroBlock = viewModel.blocks[index] as? HeroBlock {
                        HeroBlockView(block: heroBlock)
                    } else if let popularArticlesBlock = viewModel.blocks[index] as? PopularArticlesBlock {
                        ArticlesBlockView(block: popularArticlesBlock) { fullSlug in
                            // Append the slug to the navigation path
                            navigationPath.wrappedValue.append(fullSlug)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationDestination(for: String.self) { fullSlug in
            SingleArticleScreen(
                fullSlug: fullSlug,
                storyFetcher: viewModel.storyFetcher,
                navigationPath: navigationPath
            )
        }
        .onAppear {
            viewModel.fetchHomeStory()
        }
    }
}
