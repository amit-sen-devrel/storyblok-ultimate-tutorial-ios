//
//  LinksFetcher.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 14.01.25.
//


import Foundation
import Combine

final class LinksFetcher: LinksFetcherProtocol {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    /**
     Fetches links from the Storyblok API.
     
     - Returns: A publisher that emits an array of links or a network error.
     */
    func fetchLinks() -> AnyPublisher<[String: Link], NetworkError> {
        let path = "/links"
        let parameters: [String: String] = [
            "cv": "1736848911",
            "token": "0cQ0rLotjXQYEWtMK5aBWgtt",
            "version": "published"
        ]
        
        return networkManager.fetchData(from: path, parameters: parameters, type: LinksResponse.self)
            .map { $0.links }
            .eraseToAnyPublisher()
    }
}
