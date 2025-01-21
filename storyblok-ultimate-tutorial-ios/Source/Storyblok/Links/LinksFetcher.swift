//
//  LinksFetcher.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 14.01.25.
//


import Foundation
import Combine

/// Protocol defining the interface for fetching links.
protocol LinksFetcherProtocol {
    /**
     Fetches links from the Storyblok API.
     
     - Returns: A publisher that emits a dictionary of links (keyed by their unique identifier) or a `NetworkError` in case of failure.
     */
    func fetchLinks() -> AnyPublisher<[String: Link], NetworkError>
}

/// A class responsible for fetching links data from the Storyblok API.
final class LinksFetcher: LinksFetcherProtocol {
    // MARK: - Properties
    
    /// The network manager used for performing API requests.
    private let networkManager: NetworkManager
    
    // MARK: - Initializer
    
    /**
     Initializes the `LinksFetcher` with a network manager.
     
     - Parameter networkManager: An instance of `NetworkManager` to handle API requests.
     */
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // MARK: - Methods
    
    /**
     Fetches links from the Storyblok API.
     
     Links represent the hierarchical structure of stories in Storyblok. This function retrieves all available links and returns them as a dictionary where each key is a unique link identifier, and the value is a `Link` object.
     
     - Returns: A publisher that emits a dictionary of links (`[String: Link]`) on success or a `NetworkError` on failure.
     
     ### Example Usage:
     ```swift
     let linksFetcher = LinksFetcher(networkManager: NetworkManager())
     linksFetcher.fetchLinks()
         .sink(receiveCompletion: { completion in
             switch completion {
             case .finished:
                 print("Successfully fetched links.")
             case .failure(let error):
                 print("Error fetching links: \(error)")
             }
         }, receiveValue: { links in
             print("Fetched links: \(links)")
         })
         .store(in: &cancellables)
     ```
     */
    func fetchLinks() -> AnyPublisher<[String: Link], NetworkError> {
        let path = "/links" // API endpoint for fetching links
        let parameters: [String: String] = [
            "token": "0cQ0rLotjXQYEWtMK5aBWgtt", // Storyblok API token
            "version": "published" // Fetch only published links
        ]
        
        return networkManager.fetchData(from: path, parameters: parameters, type: LinksResponse.self)
            .map { $0.links } // Extract the `links` dictionary from the response
            .eraseToAnyPublisher()
    }
}
