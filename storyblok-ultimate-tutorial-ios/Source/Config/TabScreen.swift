//
//  TabScreen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//


import Foundation

enum TabScreen: String, CaseIterable {
    case home
    case articles
    case about
    case language

    /// Title for each tab
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

    /// Icon for each tab
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

    /// Slug for each screen
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
