//
//  StoryFetcher.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//

import Combine
import Foundation

protocol StoryFetcherProtocol {
    func fetchStory(slug: String, resolveRelations: [String]?) -> AnyPublisher<StoryResponse, NetworkError>
    func fetchMultipleStories(resolveRelations: [String]?, params: [String: String]) -> AnyPublisher<MultipleStoriesResponse, NetworkError>
}

final class StoryFetcher: StoryFetcherProtocol {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // MARK: - Fetch Story
    /**
     Fetches a story from the Storyblok API.
     
     - Parameters:
     - `slug`: The slug of the story to fetch.
     - `resolveRelations`: An optional array of relation fields to resolve.
     - `params`: Additional query parameters to include in the request.
     - Returns: A publisher that emits a `StoryResponse` or a `NetworkError`.
     */
    func fetchStory(
        slug: String,
        resolveRelations: [String]? = nil
    ) -> AnyPublisher<StoryResponse, NetworkError> {
        let path = "/stories/\(slug)"
        var parameters: [String: String] = [
            "version": "published",
            "token": "0cQ0rLotjXQYEWtMK5aBWgtt"
        ]
        
        // Add the resolve_relations parameter if provided
        if let resolveRelations = resolveRelations, !resolveRelations.isEmpty {
            parameters["resolve_relations"] = resolveRelations.joined(separator: ",")
        }
        
        return networkManager.fetchData(from: path, parameters: parameters, type: StoryResponse.self)
    }
    
    func fetchMultipleStories(
        resolveRelations: [String]?,
        params: [String : String]
    ) -> AnyPublisher<MultipleStoriesResponse, NetworkError> {
        let path = "/stories"
        var parameters: [String: String] = [
            "version": "published",
            "token": "0cQ0rLotjXQYEWtMK5aBWgtt"
        ]
        
        // Add the resolve_relations parameter if provided
        if let resolveRelations = resolveRelations, !resolveRelations.isEmpty {
            parameters["resolve_relations"] = resolveRelations.joined(separator: ",")
        }
        
        parameters.merge(params) { (_, new) in new }
        
        return networkManager.fetchData(from: path, parameters: parameters, type: MultipleStoriesResponse.self)
    }
}
