//
//  AboutScreen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//


import SwiftUI

/// A screen for displaying the "About Me" content.
///
/// This screen fetches and displays rich text content from the "About" story, using the `AboutViewModel`.
/// It conforms to the `Screen` protocol for consistent navigation and loading/error state management.
struct AboutScreen: Screen {
    // MARK: - Properties
    
    /// The view model that manages the data for the About screen.
    @StateObject private var viewModel: AboutViewModel
    
    /// The navigation path used for navigation within the screen.
    var navigationPath: Binding<NavigationPath>
    
    // MARK: - Initializer
    
    /// Initializes the `AboutScreen` with a view model and navigation path.
    /// - Parameters:
    ///   - viewModel: The `AboutViewModel` instance managing the screen's data.
    ///   - navigationPath: A binding to the navigation path for dynamic navigation.
    init(viewModel: AboutViewModel, navigationPath: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.navigationPath = navigationPath
    }
    
    // MARK: - Screen Protocol Properties
    
    /// The title of the screen displayed in the navigation bar.
    var title: String? {
        "About Me"
    }
    
    /// Indicates whether the screen is currently loading data.
    var isLoading: Bool {
        viewModel.isLoading
    }
    
    /// Holds the error message, if any, for display on the screen.
    var errorMessage: String? {
        viewModel.errorMessage
    }
    
    // MARK: - Screen Content
    
    /// The main content of the screen.
    var bodyContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Render the rich text content if available
                if let richContent = viewModel.richContent {
                    RichTextView(nodes: richContent) // Use the RichTextView to display parsed nodes
                } else if !isLoading && errorMessage == nil {
                    Text("No content available.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            }
            .padding(16) // Add padding to the content
        }
        .onAppear {
            viewModel.fetchAboutStory() // Fetch the story when the screen appears
        }
    }
}
