//
//  MainTabView.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//


import SwiftUI

/// The main tab-based navigation view of the app, organizing screens into tabs for easy access.
struct MainTabView: View {
    // MARK: - Dependencies
    
    @EnvironmentObject private var appInitializer: AppInitializer
    
    // MARK: - Body
    
    /// The body of the `MainTabView`, containing a `TabView` with individual tabs.
    var body: some View {
        TabView {
            // Home Tab
            NavigationStack(path: $appInitializer.homeNavigationPath) {
                PageScreen(
                    viewModel: PageViewModel(
                        storyFetcher: appInitializer.storyFetcher,
                        slug: TabScreen.home.slug,
                        title: TabScreen.home.title
                    ),
                    navigationPath: $appInitializer.homeNavigationPath
                )
            }
            .tabItem {
                Label(TabScreen.home.title, systemImage: TabScreen.home.icon)
            }
            
            // Articles Tab
            NavigationStack(path: $appInitializer.articlesNavigationPath) {
                ArticlesScreen(
                    viewModel: ArticlesViewModel(storyFetcher: appInitializer.storyFetcher),
                    navigationPath: $appInitializer.articlesNavigationPath
                )
            }
            .tabItem {
                Label(TabScreen.articles.title, systemImage: TabScreen.articles.icon)
            }
            
            // About Tab
            NavigationStack(path: $appInitializer.aboutNavigationPath) {
                PageScreen(
                    viewModel: PageViewModel(
                        storyFetcher: appInitializer.storyFetcher,
                        slug: TabScreen.about.slug,
                        title: TabScreen.about.title
                    ),
                    navigationPath: $appInitializer.aboutNavigationPath
                )
            }
            .tabItem {
                Label(TabScreen.about.title, systemImage: TabScreen.about.icon)
            }
            
            // Language Settings Tab
            NavigationStack(path: $appInitializer.languageNavigationPath) {
                LanguageSettingsScreen(navigationPath: $appInitializer.languageNavigationPath)
            }
            .tabItem {
                Label(TabScreen.language.title, systemImage: TabScreen.language.icon)
            }
        }
    }
}
