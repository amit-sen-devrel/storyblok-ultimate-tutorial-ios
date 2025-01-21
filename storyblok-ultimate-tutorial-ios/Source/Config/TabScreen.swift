//
//  TabScreen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//
//
//  This enum defines the tabs in the main tab navigation of the app, providing associated metadata
//  such as title, icon, and slug for each tab. It serves as a centralized definition for the app's tab bar.
//

import Foundation

/// Represents the available tabs in the main tab navigation.
/// Each case corresponds to a specific screen and includes metadata like title, icon, and slug.
enum TabScreen: String, CaseIterable {
    case home       // Home tab
    case articles   // Articles tab
    case about      // About tab
    case language   // Language settings tab

    /// The title displayed for each tab.
    /// This is used for the tab label and accessibility purposes.
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .articles:
            return "Articles"
        case .about:
            return "About"
        case .language:
            return "Language"
        }
    }

    /// The system icon name for each tab.
    /// These are SF Symbols used for displaying tab icons.
    /// SF Symbols ensure consistency with the iOS ecosystem and support dynamic sizing.
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .articles:
            return "doc.text"
        case .about:
            return "info.circle"
        case .language:
            return "globe"
        }
    }

    /// The unique slug used to fetch content for each screen.
    /// This is used for fetching corresponding content from the API.
    /// - Returns: A string slug if applicable; `nil` for screens that don't fetch content.
    var slug: String? {
        switch self {
        case .home:
            return "home"
        case .articles:
            return "blogs"
        case .about:
            return "about"
        case .language:
            return nil
        }
    }
}
