//
//  Screen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//

import SwiftUI

/// A protocol for feature-rich screens in the app.
protocol Screen: View {
    associatedtype Content: View
    
    /// The content of the screen.
    @ViewBuilder var bodyContent: Content { get }
    
    /// The title of the screen.
    var title: String? { get }
    
    /// Flag to determine if the screen shows a loading state.
    var isLoading: Bool { get }
    
    /// Error message for the screen, if any.
    var errorMessage: String? { get }
}

/// Provide default implementations for optional properties.
extension Screen {
    var title: String? { nil }
    var isLoading: Bool { false }
    var errorMessage: String? { nil }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Screen content
                bodyContent
                
                // Loading Indicator
                if isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                }
                
                // Error Message
                if let errorMessage = errorMessage {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                        Spacer()
                    }
                }
            }
            .navigationTitle(title ?? "")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
