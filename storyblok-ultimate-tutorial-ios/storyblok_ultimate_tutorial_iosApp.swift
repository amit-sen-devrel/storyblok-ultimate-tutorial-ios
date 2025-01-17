//
//  storyblok_ultimate_tutorial_iosApp.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 13.01.25.
//

import SwiftUI

@main
struct storyblok_ultimate_tutorial_iosApp: App {
    var body: some Scene {
        WindowGroup {
            // Initialize dependencies once
            let networkManager = NetworkManager()
            let storyFetcher = StoryFetcher(networkManager: networkManager)

            // Pass the dependencies to MainTabView
            MainTabView(storyFetcher: storyFetcher)
                .environmentObject(AppState.shared)
        }
    }
}
