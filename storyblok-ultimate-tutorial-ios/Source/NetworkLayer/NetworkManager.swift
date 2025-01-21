//
//  NetworkManager.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 14.01.25.
//
//
//  This class handles network requests and provides methods to fetch and decode data from APIs.
//

import Foundation
import Combine

/// A class responsible for managing network requests.
/// Provides methods to fetch raw data or decode data into specific types.
/// Utilizes `Combine` for reactive programming and error handling.
final class NetworkManager {
    
    // MARK: - Properties
    
    /// The URLSession instance used for network requests.
    private let session: URLSession
    
    // MARK: - Initializer
    
    /**
     Initializes the `NetworkManager` with a custom or shared `URLSession`.
     
     - Parameter session: A `URLSession` instance to use for network requests. Defaults to `.shared`.
     */
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Methods
    
    /**
     Fetches raw data from the specified API path.
     
     - Parameters:
        - path: The API endpoint path (appended to the base URL).
        - method: The HTTP method to use for the request (default: `.GET`).
        - parameters: A dictionary of query parameters to include in the request (default: empty).
     - Returns: A `Publisher` emitting the fetched data or a `NetworkError`.
     */
    func fetchData(from path: String, method: HTTPMethod = .GET, parameters: [String: String] = [:]) -> AnyPublisher<Data, NetworkError> {
        guard var url = URL(string: APIConstants.baseURL + path) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        // Add query parameters to the URL
        if !parameters.isEmpty {
            guard let updatedURL = url.appendingQueryParameters(parameters) else {
                return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
            }
            url = updatedURL
        }
        
        // Create the URLRequest with the specified method
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Perform the network request and handle responses
        return session.dataTaskPublisher(for: request)
            .tryMap { output in
                // Ensure the response is a valid HTTPURLResponse
                guard let response = output.response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                // Handle the HTTP status code
                try self.handleHTTPResponse(response)
                return output.data
            }
            .mapError { error in
                // Map errors to NetworkError types
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.requestFailed(error)
            }
            .receive(on: DispatchQueue.main)    // Switch to the main thread
            .eraseToAnyPublisher()
    }
    
    /**
     Fetches and decodes data from the specified API path into the given type.
     
     - Parameters:
        - path: The API endpoint path (appended to the base URL).
        - method: The HTTP method to use for the request (default: `.GET`).
        - parameters: A dictionary of query parameters to include in the request (default: empty).
        - type: The type to decode the fetched data into.
     - Returns: A `Publisher` emitting the decoded data or a `NetworkError`.
     */
    func fetchData<T: Codable>(from path: String, method: HTTPMethod = .GET, parameters: [String: String] = [:], type: T.Type) -> AnyPublisher<T, NetworkError> {
        return fetchData(from: path, method: method, parameters: parameters)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                // Map decoding errors to a specific NetworkError case
                if let decodingError = error as? DecodingError {
                    return NetworkError.decodingFailed(decodingError)
                }
                return error as? NetworkError ?? NetworkError.requestFailed(error)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Helper Methods
    
    /**
     Validates the HTTP response and throws an error for non-successful status codes.
     
     - Parameter response: The `HTTPURLResponse` to validate.
     - Throws: A `NetworkError` if the status code indicates an error.
     */
    private func handleHTTPResponse(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...299:
            // Success
            break
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 422:
            throw NetworkError.unprocessableEntity
        case 429:
            throw NetworkError.tooManyRequests
        case 500...599:
            throw NetworkError.serverError
        default:
            throw NetworkError.invalidResponse
        }
    }
}
