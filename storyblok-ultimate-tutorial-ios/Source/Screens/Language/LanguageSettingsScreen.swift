//
//  LanguageSettingsScreen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//


import SwiftUI

struct LanguageSettingsScreen: Screen {
    var navigationPath: Binding<NavigationPath>
    
    @EnvironmentObject private var appState: AppState
    @State private var selectedLanguage: Language = AppState.shared.language
    
    // Mock data for languages
    private let languages: [Language] = [.english, .german]
    
    init(navigationPath: Binding<NavigationPath>) {
        self.navigationPath = navigationPath
    }
    
    var bodyContent: some View {
        NavigationView {
            List(languages, id: \ .code) { language in
                LanguageCard(language: language, isSelected: language == selectedLanguage)
                    .onTapGesture {
                        if selectedLanguage != language {
                            selectedLanguage = language
                            appState.language = language // Update app-wide language
                        }
                    }
            }
            .navigationTitle("Language Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
