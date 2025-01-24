//
//  AppInitializer.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 23.01.25.
//


import SwiftUI

final class AppInitializer: ObservableObject {
    static let shared = AppInitializer()

    let networkManager: NetworkManager
    let storyFetcher: StoryFetcher

    // Centralized navigation paths for each tab
    @Published var homeNavigationPath = NavigationPath()
    @Published var articlesNavigationPath = NavigationPath()
    @Published var aboutNavigationPath = NavigationPath()
    @Published var languageNavigationPath = NavigationPath()

    private init() {
        // Initialize the dependencies
        networkManager = NetworkManager()
        storyFetcher = StoryFetcher(networkManager: networkManager)

        // Register blocks in the registry
        configureBlockRegistry()
    }

    /// Configures the block registry with all the available blocks and their views.
    private func configureBlockRegistry() {
        let registry = BlockRegistry.shared

        // Register HeroBlockView
        registry.registerBlock(for: "hero") { (block: HeroBlock) in
            AnyView(HeroBlockView(block: block))
        }

        // Register PopularArticlesBlockView
        registry.registerBlock(for: "popular-articles") { (block: PopularArticlesBlock) in
            AnyView(ArticlesBlockView(block: block) { fullSlug in
                print("Navigate to \(fullSlug)") // Handle navigation if needed
                AppInitializer.shared.homeNavigationPath.append(
                    NavigationDestination.singleArticle(slug: "blogs/\(fullSlug)")
                )
            })
        }

        // Register BigTextBlockView
        registry.registerBlock(for: "big_text") { (block: BigTextBlock) in
            AnyView(BigTextBlockView(block: block))
        }

        // Add other blocks as needed
    }
}
