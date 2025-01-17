//
//  HomeViewModel.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import Combine
import SwiftUI

final class HomeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var blocks: [Decodable] = []
    
    private let slug: String
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    let storyFetcher: StoryFetcher
    
    // MARK: - Initializer
    init(storyFetcher: StoryFetcher, slug: String? = nil) {
        self.storyFetcher = storyFetcher
        self.slug = slug ?? ""
    }
    
    // MARK: - Fetch Home Story
    func fetchHomeStory() {
        isLoading = true
        errorMessage = nil
        
        storyFetcher.fetchStory(slug: self.slug, resolveRelations: ["popular-articles.articles"])
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
                if let bodyArray = storyResponse.story.content.fields["body"]?.toArray() {
                    self.blocks = bodyArray.compactMap { contentValue in
                        return BlockMapper.map(contentValue: contentValue, resolver: resolver)
                    }
                } else {
                    self.blocks = []
                }
            })
            .store(in: &cancellables)
        
    }
    
    deinit {
        print("HomeViewModel deallocated")
    }
}
