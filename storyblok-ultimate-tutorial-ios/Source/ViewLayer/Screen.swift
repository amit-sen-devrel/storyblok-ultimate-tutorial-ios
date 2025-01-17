//
//  Screen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//

import SwiftUI

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
    
    /// Navigation path for dynamic navigation.
    var navigationPath: Binding<NavigationPath> { get }
}

extension Screen {
    var title: String? { nil }
    var isLoading: Bool { false }
    var errorMessage: String? { nil }
    
    var body: some View {
        ZStack {
            // Screen content
            bodyContent
            
            // Loading Indicator
            if isLoading {
                ZStack {
                    Color.black.opacity(0.5) // Optional dimmed background
                        .ignoresSafeArea()
                    ProgressView("Loading...")
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.9))
                        )
                        .shadow(radius: 10)
                }
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
        .navigationBarTitleDisplayMode(.large)
    }
}
