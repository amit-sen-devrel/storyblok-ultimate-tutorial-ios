//
//  StoryFetcher.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//

import Combine
import Foundation

/// A protocol defining methods to fetch stories from the Storyblok API.
protocol StoryFetcherProtocol {
    /**
     Fetches a single story from the Storyblok API.
     
     - Parameters:
       - slug: The slug of the story to fetch.
       - resolveRelations: An optional array of relation fields to resolve.
     - Returns: A publisher emitting a `StoryResponse` or a `NetworkError`.
     */
    func fetchStory(slug: String, resolveRelations: [String]?) -> AnyPublisher<StoryResponse, NetworkError>
    
    /**
     Fetches multiple stories from the Storyblok API with optional filters.
     
     - Parameters:
       - resolveRelations: An optional array of relation fields to resolve.
       - params: Additional query parameters to include in the request.
     - Returns: A publisher emitting a `MultipleStoriesResponse` or a `NetworkError`.
     */
    func fetchMultipleStories(resolveRelations: [String]?, params: [String: String]) -> AnyPublisher<MultipleStoriesResponse, NetworkError>
}

/// A class responsible for fetching story data from the Storyblok API.
final class StoryFetcher: StoryFetcherProtocol {
    
    // MARK: - Properties
    
    /// The network manager used to make API calls.
    private let networkManager: NetworkManager
    
    // MARK: - Initializer
    
    /**
     Initializes the `StoryFetcher` with a network manager.
     
     - Parameter networkManager: The `NetworkManager` instance for performing network requests.
     */
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // MARK: - Fetch Single Story
    
    /**
     Fetches a single story from the Storyblok API.
     
     - Parameters:
       - slug: The unique slug of the story to fetch.
       - resolveRelations: An optional array of relation fields (e.g., "author", "categories") to resolve.
     
     - Returns: A publisher emitting a `StoryResponse` object or a `NetworkError`.
     
     ### Details:
     - This method constructs a URL with the given `slug`, appends necessary query parameters (e.g., API token, version),
       and optionally includes relational data to resolve.
     - Uses `AppState.shared.language.code` to set the language dynamically.
     
     ### Example Usage:
     ```swift
     storyFetcher.fetchStory(slug: "home", resolveRelations: ["popular-articles.articles"])
     ```
     */
    func fetchStory(
        slug: String,
        resolveRelations: [String]? = nil
    ) -> AnyPublisher<StoryResponse, NetworkError> {
        let path = "/stories/\(slug)"
        var parameters: [String: String] = [
            "version": "published", // Fetch only published stories
            "token": "0cQ0rLotjXQYEWtMK5aBWgtt", // Authentication token
            "language": AppState.shared.language.code ?? "" // Language code from AppState
        ]
        
        // Include relation resolution if specified
        if let resolveRelations = resolveRelations, !resolveRelations.isEmpty {
            parameters["resolve_relations"] = resolveRelations.joined(separator: ",")
        }
        
        // Perform the network request
        return networkManager.fetchData(from: path, parameters: parameters, type: StoryResponse.self)
    }
    
    // MARK: - Fetch Multiple Stories
    
    /**
     Fetches multiple stories from the Storyblok API with additional filtering options.
     
     - Parameters:
       - resolveRelations: An optional array of relation fields (e.g., "author", "categories") to resolve.
       - params: A dictionary of additional query parameters for filtering.
     
     - Returns: A publisher emitting a `MultipleStoriesResponse` object or a `NetworkError`.
     
     ### Details:
     - This method is useful for fetching a list of stories (e.g., articles, categories) based on specific criteria.
     - Combines default parameters with additional ones provided in `params`.
     - Uses `AppState.shared.language.code` to fetch stories in the selected language.
     
     ### Example Usage:
     ```swift
     let params = [
         "starts_with": "blogs/", // Fetch stories under the "blogs/" folder
         "is_startpage": "false" // Exclude start pages
     ]
     storyFetcher.fetchMultipleStories(resolveRelations: ["author"], params: params)
     ```
     */
    func fetchMultipleStories(
        resolveRelations: [String]?,
        params: [String: String]
    ) -> AnyPublisher<MultipleStoriesResponse, NetworkError> {
        let path = "/stories"
        var parameters: [String: String] = [
            "version": "published", // Fetch only published stories
            "token": "0cQ0rLotjXQYEWtMK5aBWgtt", // Authentication token
            "language": AppState.shared.language.code ?? "" // Language code from AppState
        ]
        
        // Include relation resolution if specified
        if let resolveRelations = resolveRelations, !resolveRelations.isEmpty {
            parameters["resolve_relations"] = resolveRelations.joined(separator: ",")
        }
        
        // Merge additional query parameters
        parameters.merge(params) { (_, new) in new }
        
        // Perform the network request
        return networkManager.fetchData(from: path, parameters: parameters, type: MultipleStoriesResponse.self)
    }
}
