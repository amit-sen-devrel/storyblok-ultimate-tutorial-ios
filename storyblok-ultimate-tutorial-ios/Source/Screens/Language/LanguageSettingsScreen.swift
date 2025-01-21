//
//  LanguageSettingsScreen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//


import SwiftUI

/// A screen for selecting the app's language settings.
struct LanguageSettingsScreen: Screen {
    // MARK: - Properties
    
    /// The navigation path for handling navigation state.
    var navigationPath: Binding<NavigationPath>
    
    /// The shared app state for managing global settings like the selected language.
    @EnvironmentObject private var appState: AppState
    
    /// The currently selected language.
    @State private var selectedLanguage: Language = AppState.shared.language
    
    /// The list of available languages for selection.
    private let languages: [Language] = [.english, .german]
    
    // MARK: - Initializer
    
    /**
     Initializes the LanguageSettingsScreen with a navigation path.
     
     - Parameter navigationPath: A binding to the navigation path for dynamic navigation.
     */
    init(navigationPath: Binding<NavigationPath>) {
        self.navigationPath = navigationPath
    }
    
    // MARK: - Screen Content
    
    /// The main content of the screen.
    var bodyContent: some View {
        NavigationView {
            // List of languages
            List(languages, id: \.code) { language in
                LanguageCard(language: language, isSelected: language == selectedLanguage)
                    .onTapGesture {
                        // Update the selected language if it changes
                        if selectedLanguage != language {
                            selectedLanguage = language
                            appState.language = language // Update the app-wide language
                        }
                    }
            }
            .navigationTitle("Language Settings") // Title for the navigation bar
            .navigationBarTitleDisplayMode(.inline) // Inline display for compact layout
        }
    }
}
