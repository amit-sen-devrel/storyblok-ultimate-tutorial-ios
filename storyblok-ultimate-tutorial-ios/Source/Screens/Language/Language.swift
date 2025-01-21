//
//  Language.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//

import Foundation

/// Represents a language option in the app, including its name, code, and associated flag emoji.
struct Language: Identifiable, Equatable {
    /// Unique identifier for each language.
    let id = UUID()
    
    /// Display name of the language (e.g., "English").
    let name: String
    
    /// Language code used for localization or API requests (e.g., "en" for English, "de" for German).
    /// If `nil`, it indicates the default language.
    let code: String?
    
    /// Flag emoji representing the language or its primary region.
    let flag: String
}

extension Language {
    // MARK: - Predefined Language Options
    
    /// Default language: English.
    static let english: Language = .init(
        name: "English",
        code: nil, // Represents the default language
        flag: "🇬🇧"
    )
    
    /// German language option.
    static let german: Language = .init(
        name: "German",
        code: "de",
        flag: "🇩🇪"
    )
}
