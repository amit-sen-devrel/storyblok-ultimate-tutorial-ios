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
                    viewModel: HomeViewModel(storyFetcher: storyFetcher),
                    navigationPath: $homeNavigationPath
                )
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            NavigationStack(path: $articlesNavigationPath) {
                Text("Articles Screen Placeholder")
                    .font(.title)
            }
            .tabItem {
                Label("Articles", systemImage: "doc.text")
            }

            NavigationStack(path: $aboutNavigationPath) {
                Text("About Screen Placeholder")
                    .font(.title)
            }
            .tabItem {
                Label("About", systemImage: "info.circle")
            }

            NavigationStack(path: $languageNavigationPath) {
                Text("Language Settings Screen Placeholder")
                    .font(.title)
            }
            .tabItem {
                Label("Language", systemImage: "globe")
            }
        }
    }
}
