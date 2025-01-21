//
//  ArticlesViewModel.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//


import Foundation
import Combine

/// A view model for managing the "Articles" screen.
///
/// This view model handles fetching article data from the Storyblok API and provides it to the view for rendering.
final class ArticlesViewModel: ObservableObject {
    // MARK: - Properties
    
    /// The story fetcher instance used to fetch articles.
    let storyFetcher: StoryFetcher
    
    /// A set of Combine cancellables to manage subscriptions.
    private var cancellables = Set<AnyCancellable>()

    /// Indicates whether data is currently being loaded.
    @Published var isLoading: Bool = false

    /// Holds any error message encountered during data fetching.
    @Published var errorMessage: String?

    /// An array of article cards to display in the view.
    @Published var articleCards: [ArticleCard] = []

    // MARK: - Initializer
    
    /// Initializes the view model with a story fetcher.
    /// - Parameter storyFetcher: The `StoryFetcher` instance used to fetch data.
    init(storyFetcher: StoryFetcher) {
        self.storyFetcher = storyFetcher
    }

    // MARK: - Fetch All Articles
    
    /// Fetches all articles starting with the "blogs/" slug from the Storyblok API.
    ///
    /// This method constructs the appropriate parameters for the API call and processes the response to populate `articleCards`.
    /// Handles loading and error states to provide feedback to the view.
    func fetchAllArticles() {
        // Set loading state to true and clear any existing error
        isLoading = true
        errorMessage = nil

        // Parameters for fetching articles
        let params = [
            "starts_with": "blogs/",       // Fetch articles under the "blogs/" path
            "is_startpage": "false"       // Exclude start pages
        ]
        
        storyFetcher.fetchMultipleStories(resolveRelations: nil, params: params)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    self.isLoading = false // Stop loading when the operation completes
                    
                    // Handle errors
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] storiesResponse in
                    guard let self = self else { return }
                    
                    // Map stories to `ArticleCard` objects
                    self.articleCards = storiesResponse.stories.compactMap { story in
                        ArticleCard(
                            uuid: story.uuid,
                            title: story.content.fields["title"]?.toString() ?? "No Title",
                            teaser: story.content.fields["teaser"]?.toString() ?? "",
                            image: story.content.fields["image"]?.toAsset(),
                            fullSlug: story.slug
                        )
                    }
                }
            )
            .store(in: &cancellables) // Store the subscription
    }
}
