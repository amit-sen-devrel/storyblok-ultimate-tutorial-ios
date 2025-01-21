//
//  HomeViewModel.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import Combine
import SwiftUI

/// ViewModel responsible for managing the state and logic of the Home screen.
final class HomeViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// Indicates whether data is currently being loaded.
    @Published var isLoading: Bool = false
    
    /// Holds any error message if the data fetch fails.
    @Published var errorMessage: String? = nil
    
    /// Stores the blocks to render on the Home screen. Each block is decoded dynamically.
    @Published var blocks: [Decodable] = []
    
    // MARK: - Private Properties
    
    /// The slug of the home story to fetch.
    private let slug: String
    
    /// Set of cancellables to manage Combine subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    /// The `StoryFetcher` instance used to fetch data.
    let storyFetcher: StoryFetcher
    
    // MARK: - Initializer
    
    /**
     Initializes the `HomeViewModel` with a `StoryFetcher` and an optional slug.
     
     - Parameters:
       - storyFetcher: The `StoryFetcher` instance used for API requests.
       - slug: An optional slug for the Home story. Defaults to an empty string.
     */
    init(storyFetcher: StoryFetcher, slug: String? = nil) {
        self.storyFetcher = storyFetcher
        self.slug = slug ?? ""
    }
    
    // MARK: - Fetch Home Story
    
    /**
     Fetches the Home story from the API.
     
     The method retrieves the Home story, resolves relations for nested content (e.g., articles in the `popular-articles` block), and maps the `body` field of the story into decodable blocks for rendering.
     
     - Resolves relations for `popular-articles.articles`.
     - Updates the `blocks` property with dynamically mapped blocks.
     */
    func fetchHomeStory() {
        // Start loading
        isLoading = true
        errorMessage = nil
        
        storyFetcher.fetchStory(slug: self.slug, resolveRelations: ["popular-articles.articles"])
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                // Stop loading on completion
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Handle error
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] storyResponse in
                guard let self = self else { return }
                let resolver = StoryRelationResolver(storyResponse.rels)
                if let bodyArray = storyResponse.story.content.fields["body"]?.toArray() {
                    // Map the body array to decodable blocks
                    self.blocks = bodyArray.compactMap { contentValue in
                        return BlockMapper.map(contentValue: contentValue, resolver: resolver)
                    }
                } else {
                    self.blocks = []
                }
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Deinitializer
    
    /// Deinitializer to observe when the ViewModel is deallocated.
    deinit {
        print("HomeViewModel deallocated")
    }
}
