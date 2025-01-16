//
//  HomeScreen.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//

import SwiftUI

struct HomeScreen: Screen {
    @StateObject private var viewModel: HomeViewModel

    // MARK: - Initializer
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Screen Title
    var title: String? {
        "Home"
    }

    // MARK: - Loading and Error State
    var isLoading: Bool {
        viewModel.isLoading
    }

    var errorMessage: String? {
        viewModel.errorMessage
    }

    // MARK: - Screen Content
    var bodyContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.blocks.indices, id: \ .self) { index in
                    if let heroBlock = viewModel.blocks[index] as? HeroBlock {
                        HeroBlockView(block: heroBlock)
                    } else if let popularArticlesBlock = viewModel.blocks[index] as? PopularArticlesBlock {
                        PopularArticlesBlockView(block: popularArticlesBlock)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchHomeStory()
        }
    }
}
