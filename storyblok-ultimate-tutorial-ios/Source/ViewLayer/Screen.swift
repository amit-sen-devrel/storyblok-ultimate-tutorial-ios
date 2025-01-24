//
//  Screen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//

import SwiftUI

/// A protocol defining the structure of a reusable and feature-rich screen in the app.
protocol Screen: View {
    associatedtype Content: View
    
    /// The main content of the screen, to be implemented by conforming types.
    @ViewBuilder var bodyContent: Content { get }
    
    /// The title displayed in the navigation bar. Defaults to `nil` if not specified.
    var title: String? { get }
    
    /// A flag indicating whether the screen is in a loading state. Defaults to `false`.
    var isLoading: Bool { get }
    
    /// An optional error message to display on the screen. Defaults to `nil`.
    var errorMessage: String? { get }
    
    /// A binding to the `NavigationPath` for dynamic navigation handling.
    var navigationPath: Binding<NavigationPath> { get }
}

/// Provides default implementations and behaviors for the `Screen` protocol.
extension Screen {
    // MARK: - Default Values
    
    /// The default title is `nil`, which means no title will be displayed unless overridden.
    var title: String? { nil }
    
    /// The default loading state is `false`.
    var isLoading: Bool { false }
    
    /// The default error message is `nil`.
    var errorMessage: String? { nil }
    
    // MARK: - View Composition
    
    /// The main body of the screen, combining dynamic content, loading states, and error handling.
    var body: some View {
        ZStack {
            // 1. The primary screen content provided by the conforming type.
            bodyContent
            
            // 2. Loading Indicator
            if isLoading {
                ZStack {
                    Color.black.opacity(0.5) // Optional dimmed background for better visual emphasis.
                        .ignoresSafeArea()  // Ensures the background covers the full screen.
                    ProgressView("Loading...") // A simple loading indicator.
                        .foregroundColor(.white) // Makes the text visible against the dimmed background.
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8) // Adds a rounded rectangle around the loading indicator.
                                .fill(Color.white.opacity(0.9)) // Semi-transparent background for better visibility.
                        )
                        .shadow(radius: 10) // Adds a shadow for a subtle elevated effect.
                }
            }
            
            // 3. Error Message
            if let errorMessage = errorMessage {
                VStack {
                    Text(errorMessage) // Displays the error message.
                        .foregroundColor(.red) // Highlights the error in red.
                        .padding()
                    Spacer() // Pushes the error message to the top.
                }
            }
        }
        .navigationTitle(title ?? "") // Sets the navigation bar title if provided.
        .navigationBarTitleDisplayMode(.inline) // Uses a large title style for better visibility.
        .toolbar {
            // Display the title in the toolbar
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(title ?? "")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
}
