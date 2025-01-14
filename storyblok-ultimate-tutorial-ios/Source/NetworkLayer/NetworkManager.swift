//
//  NetworkManager.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 14.01.25.
//

import Foundation
import Combine

/// A class that manages network requests.
final class NetworkManager: NetworkService {
    
    // MARK: - Properties
    private let session: URLSession
    
    // MARK: - Initializer
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Methods
    
    /**
     Fetches data from the given URL string.
     
     - Parameter urlString: The URL string to fetch data from.
     - Returns: A publisher with the fetched data or a network error.
     */
    func fetchData(from urlString: String) -> AnyPublisher<Data, NetworkError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                try self.handleHTTPResponse(response)
                return output.data
            }
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.requestFailed(error)
            }
            .eraseToAnyPublisher()
    }
    
    /**
     Fetches and decodes data from the given URL string.
     
     - Parameter urlString: The URL string to fetch data from.
     - Parameter type: The type of the decoded data.
     - Returns: A publisher with the decoded data or a network error.
     */
    func fetchDecodedData<T: Codable>(from urlString: String, type: T.Type) -> AnyPublisher<T, NetworkError> {
        return fetchData(from: urlString)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return NetworkError.decodingFailed(decodingError)
                }
                return error as? NetworkError ?? NetworkError.requestFailed(error)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Helper to Handle HTTP Status Codes
    
    /**
     Handles the HTTP response status codes.
     
     - Parameter response: The HTTPURLResponse to handle.
     - Throws: A network error if the response status code is not successful.
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
