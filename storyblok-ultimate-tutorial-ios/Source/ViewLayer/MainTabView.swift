//
//  MainTabView.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//


import SwiftUI

struct MainTabView: View {
    let storyFetcher: StoryFetcher
    
    @State private var homeNavigationPath = NavigationPath()
    @State private var articlesNavigationPath = NavigationPath()
    @State private var aboutNavigationPath = NavigationPath()
    @State private var languageNavigationPath = NavigationPath()
    
    var body: some View {
        TabView {
            NavigationStack(path: $homeNavigationPath) {
                HomeScreen(
                    viewModel: HomeViewModel(storyFetcher: storyFetcher, slug: TabScreen.home.slug),
                    navigationPath: $homeNavigationPath
                )
            }
            .tabItem {
                Label(TabScreen.home.title, systemImage: TabScreen.home.icon)
            }
            
            NavigationStack(path: $articlesNavigationPath) {
                ArticlesScreen(
                    viewModel: ArticlesViewModel(storyFetcher: storyFetcher),
                    navigationPath: $articlesNavigationPath
                )
            }
            .tabItem {
                Label(TabScreen.articles.title, systemImage: TabScreen.articles.icon)
            }
            
            NavigationStack(path: $aboutNavigationPath) {
                AboutScreen(viewModel: AboutViewModel(
                    storyFetcher: storyFetcher, slug: TabScreen.about.slug
                ), navigationPath: $aboutNavigationPath)
            }
            .tabItem {
                Label(TabScreen.about.title, systemImage: TabScreen.about.icon)
            }
            
            NavigationStack(path: $languageNavigationPath) {
                Text("Language Settings Screen Placeholder")
                    .font(.title)
            }
            .tabItem {
                Label(TabScreen.language.title, systemImage: TabScreen.language.icon)
            }
        }
    }
}
