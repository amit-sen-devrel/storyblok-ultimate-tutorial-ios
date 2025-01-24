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
            // Perform app-wide initialization
            let appInitializer = AppInitializer.shared
            
            // Pass the dependencies to MainTabView
            MainTabView()
                            .environmentObject(appInitializer)
                            .environmentObject(AppState.shared)
        }
    }
}
