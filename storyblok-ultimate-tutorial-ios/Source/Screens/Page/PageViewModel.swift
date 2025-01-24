//
//  PageViewModel.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 23.01.25.
//


import Combine
import Foundation
import SwiftUI

/// ViewModel for the DynamicScreen, responsible for fetching and processing dynamic stories.
final class PageViewModel: ObservableObject {
    // MARK: - Properties
    let storyFetcher: StoryFetcher
    private let slug: String
    var title: String?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var blockViews: [AnyView] = []
    
    // MARK: - Initializer
    init(storyFetcher: StoryFetcher, slug: String? = nil, title: String? = nil) {
        self.storyFetcher = storyFetcher
        self.slug = slug ?? ""
        self.title = title
    }
    
    // MARK: - Fetch Story
    /// Fetches the story for the given slug and resolves blocks dynamically.
    func fetchStory() {
        isLoading = true
        errorMessage = nil
        
        storyFetcher.fetchStory(slug: slug, resolveRelations: ["popular-articles.articles"])
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] storyResponse in
                guard let self = self else { return }
                let resolver = StoryRelationResolver(storyResponse.rels)
                if let bodyBlocks = storyResponse.story.content.fields["body"]?.toArray() {
                    self.blockViews = bodyBlocks.compactMap { contentValue in
                        if let heroBlockView = BlockMapper.map(contentValue: contentValue, as: HeroBlock.self, resolver: resolver) {
                            return heroBlockView
                        } else if let popularArticlesBlockView = BlockMapper.map(contentValue: contentValue, as: PopularArticlesBlock.self, resolver: resolver) {
                            self.title = storyResponse.story.name
                            return popularArticlesBlockView
                        } else if let bigTextBlockView = BlockMapper.map(contentValue: contentValue, as: BigTextBlock.self, resolver: resolver) {
                            return bigTextBlockView
                        } else {
                            print("Unhandled block type")
                            return nil
                        }
                    }
                } else {
                    self.title = storyResponse.story.name
                    self.blockViews = [
                        BlockMapper.mapSingleArticleBlock(storyResponse: storyResponse)
                    ].compactMap { $0 }
                }
            })
            .store(in: &cancellables)
    }
}
