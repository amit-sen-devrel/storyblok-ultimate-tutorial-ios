//
//  LanguageCard.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//

import SwiftUI

/// A view representing a selectable language card with flag, name, code, and a selection indicator.
struct LanguageCard: ViewComponent {
    /// The language represented by the card.
    let language: Language
    
    /// Indicates if the language is currently selected.
    let isSelected: Bool

    /// The main content of the card.
    var bodyContent: some View {
        HStack(spacing: 16) {
            // Display the flag emoji for the language
            Text(language.flag)
                .font(.largeTitle)

            VStack(alignment: .leading, spacing: 4) {
                // Display the language name
                Text(language.name)
                    .font(.headline)
                
                // Display the language code (default to "en" if nil)
                Text(language.code ?? "en")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            // Show a checkmark if the language is selected
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground)) // Background color matching system theme
        .cornerRadius(8) // Rounded corners for a modern look
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Subtle shadow for elevation
    }
}
