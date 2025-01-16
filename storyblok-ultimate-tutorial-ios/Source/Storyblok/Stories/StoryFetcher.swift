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
}

final class StoryFetcher: StoryFetcherProtocol {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchStory(slug: String, resolveRelations: [String]? = nil) -> AnyPublisher<StoryResponse, NetworkError> {
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
}
