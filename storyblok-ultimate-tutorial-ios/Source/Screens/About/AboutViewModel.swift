//
//  AboutViewModel.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//


import Foundation
import Combine

/// ViewModel for managing the data and logic of the About screen.
///
/// This class is responsible for fetching the story content for the About page from the Storyblok API
/// and extracting the rich text content to be displayed.
final class AboutViewModel: ObservableObject {
    // MARK: - Properties
    
    /// The `StoryFetcher` used to fetch story data.
    private let storyFetcher: StoryFetcher
    
    /// A set of cancellables for Combine subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    /// The slug of the About story.
    private let slug: String

    /// Indicates whether data is currently being loaded.
    @Published var isLoading: Bool = false
    
    /// Holds an error message if an error occurs during data fetching.
    @Published var errorMessage: String?
    
    /// The parsed rich text content to be displayed.
    @Published var richContent: [RichTextNode]? // Parsed rich text content

    // MARK: - Initializer
    
    /// Initializes the `AboutViewModel` with the necessary dependencies.
    /// - Parameters:
    ///   - storyFetcher: The `StoryFetcher` instance for fetching story data.
    ///   - slug: The slug for the About story. Defaults to `nil`.
    init(storyFetcher: StoryFetcher, slug: String? = nil) {
        self.storyFetcher = storyFetcher
        self.slug = slug ?? "" // Use an empty string if no slug is provided.
    }

    // MARK: - Fetch About Story
    
    /// Fetches the story content for the About page.
    ///
    /// This method uses the `StoryFetcher` to retrieve the story associated with the slug.
    /// It extracts the rich text content from the story's body field and assigns it to `richContent`.
    func fetchAboutStory() {
        isLoading = true
        errorMessage = nil

        storyFetcher.fetchStory(slug: self.slug, resolveRelations: nil)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                // Handle completion cases
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription // Set the error message on failure
                }
            }, receiveValue: { [weak self] storyResponse in
                guard let self = self else { return }

                // Extract rich text content from the story response
                if let body = storyResponse.story.content.fields["body"]?.toArray(), // Get the body array
                   let firstBlock = body.first?.toDictionary(), // Extract the first block as a dictionary
                   let richTextContent = firstBlock["text"]?.toRichText() { // Convert "text" field to rich text
                    self.richContent = richTextContent
                } else {
                    self.richContent = nil // No content found, set to nil
                }
            })
            .store(in: &cancellables) // Store the subscription
    }
}
