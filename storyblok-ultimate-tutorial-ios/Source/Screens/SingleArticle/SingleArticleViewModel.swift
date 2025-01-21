//
//  SingleArticleViewModel.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import Combine

/// ViewModel responsible for fetching and managing the data of a single article.
final class SingleArticleViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// Indicates whether the data is currently being loaded.
    @Published var isLoading = false
    
    /// Error message if an error occurs during the fetch process.
    @Published var errorMessage: String?
    
    /// The article block representing the fetched article's content.
    @Published var articleBlock: ArticleBlock?
    
    // MARK: - Private Properties
    
    /// The slug (path) of the article to fetch.
    private let fullSlug: String
    
    /// The StoryFetcher instance used to fetch the story data.
    private let storyFetcher: StoryFetcher
    
    /// A set of cancellable subscriptions for Combine publishers.
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    /**
     Initializes the `SingleArticleViewModel` with the required slug and StoryFetcher.
     
     - Parameters:
        - fullSlug: The slug of the article to fetch.
        - storyFetcher: The StoryFetcher instance used to retrieve story data from the API.
     */
    init(fullSlug: String, storyFetcher: StoryFetcher) {
        self.fullSlug = fullSlug
        self.storyFetcher = storyFetcher
    }
    
    // MARK: - Fetch Article
    
    /**
     Fetches the article data from the API using the specified slug.
     
     This method uses the `StoryFetcher` to fetch the story data corresponding to the provided slug.
     It then maps the fetched data into an `ArticleBlock` for use in the UI.
     
     - The `isLoading` property is set to `true` while the data is being fetched.
     - If an error occurs, the `errorMessage` property is updated with the error description.
     - On success, the `articleBlock` property is populated with the article's content.
     */
    func fetchArticle() {
        // Set loading state to true and clear previous error messages
        isLoading = true
        errorMessage = nil
        
        // Fetch the story from the Storyblok API
        storyFetcher.fetchStory(slug: "blogs/\(fullSlug)")
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false // End the loading state
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Handle any errors by updating the error message
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] storyResponse in
                guard let self = self else { return }
                
                // Parse the fetched story data into an ArticleBlock
                self.articleBlock = ArticleBlock(
                    title: storyResponse.story.content.fields["title"]?.toString() ?? "",
                    teaser: storyResponse.story.content.fields["teaser"]?.toString() ?? "",
                    image: storyResponse.story.content.fields["image"]?.toAsset(),
                    richContent: storyResponse.story.content.fields["content"]?.toRichText()
                )
            })
            .store(in: &cancellables) // Store the subscription in the cancellables set
    }
}
