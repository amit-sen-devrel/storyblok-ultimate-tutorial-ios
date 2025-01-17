//
//  AboutScreen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//


import SwiftUI

struct AboutScreen: Screen {
    @StateObject private var viewModel: AboutViewModel
    var navigationPath: Binding<NavigationPath>
    
    init(viewModel: AboutViewModel, navigationPath: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.navigationPath = navigationPath
    }
    
    var title: String? {
        "About Me"
    }
    
    var isLoading: Bool {
        viewModel.isLoading
    }
    
    var errorMessage: String? {
        viewModel.errorMessage
    }
    
    var bodyContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let richContent = viewModel.richContent {
                    RichTextView(nodes: richContent)
                }
            }
            .padding(16)
        }
        .onAppear {
            viewModel.fetchAboutStory()
        }
    }
}
