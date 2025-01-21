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
    
    /// The `StoryFetcher` instance used for fetching content across the app.
    let storyFetcher: StoryFetcher
    
    // MARK: - State Properties
    
    /// Navigation path for the Home tab.
    @State private var homeNavigationPath = NavigationPath()
    
    /// Navigation path for the Articles tab.
    @State private var articlesNavigationPath = NavigationPath()
    
    /// Navigation path for the About tab.
    @State private var aboutNavigationPath = NavigationPath()
    
    /// Navigation path for the Language Settings tab.
    @State private var languageNavigationPath = NavigationPath()
    
    // MARK: - Body
    
    /// The body of the `MainTabView`, containing a `TabView` with individual tabs.
    var body: some View {
        TabView {
            // Home Tab
            NavigationStack(path: $homeNavigationPath) {
                HomeScreen(
                    viewModel: HomeViewModel(
                        storyFetcher: storyFetcher,
                        slug: TabScreen.home.slug
                    ),
                    navigationPath: $homeNavigationPath
                )
            }
            .tabItem {
                Label(TabScreen.home.title, systemImage: TabScreen.home.icon)
            }
            
            // Articles Tab
            NavigationStack(path: $articlesNavigationPath) {
                ArticlesScreen(
                    viewModel: ArticlesViewModel(storyFetcher: storyFetcher),
                    navigationPath: $articlesNavigationPath
                )
            }
            .tabItem {
                Label(TabScreen.articles.title, systemImage: TabScreen.articles.icon)
            }
            
            // About Tab
            NavigationStack(path: $aboutNavigationPath) {
                AboutScreen(
                    viewModel: AboutViewModel(
                        storyFetcher: storyFetcher,
                        slug: TabScreen.about.slug
                    ),
                    navigationPath: $aboutNavigationPath
                )
            }
            .tabItem {
                Label(TabScreen.about.title, systemImage: TabScreen.about.icon)
            }
            
            // Language Settings Tab
            NavigationStack(path: $languageNavigationPath) {
                LanguageSettingsScreen(navigationPath: $languageNavigationPath)
            }
            .tabItem {
                Label(TabScreen.language.title, systemImage: TabScreen.language.icon)
            }
        }
    }
}
