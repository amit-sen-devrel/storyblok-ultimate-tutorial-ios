//
//  AppState.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//
//
//  This class manages global application state, such as the current language.
//  It serves as a single source of truth for shared state and facilitates reactive updates
//  across the app using SwiftUI's `@EnvironmentObject` and `Combine`.
//

import Foundation
import Combine
import SwiftUI

/// `AppState` is a singleton class responsible for managing global application state.
/// It provides a centralized place to store and update app-wide settings, such as the selected language.
/// The class uses the `@Published` property wrapper to notify views of state changes, ensuring reactive UI updates.
final class AppState: ObservableObject {
    static let shared = AppState()
    
    private init() {}
    
    /// The current language of the app.
    /// The default language is set to `.english` to ensure that the app has a valid fallback.
    /// Changes to this property will automatically trigger UI updates for views observing it.
    @Published var language: Language = .english // Default language
    
    @Published var currentNavigationPath: NavigationPath?
}
