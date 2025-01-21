//
//  APIConstants.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 14.01.25.
//
//
//  This file defines constants used for making API requests, providing a single source of truth
//  for API-related configuration in the app.
//

/// A struct to hold API-related constants.
/// Centralizing these constants ensures consistency across the app and simplifies maintenance.
struct APIConstants {
    
    /// The base URL for the Storyblok API.
    /// This URL serves as the foundation for all API endpoints.
    ///
    /// - Example: `"https://api.storyblok.com/v2/cdn"`
    /// - Usage:
    ///     ```
    ///     let url = "\(APIConstants.baseURL)/stories/home"
    ///     ```
    static let baseURL = "https://api.storyblok.com/v2/cdn"
}
