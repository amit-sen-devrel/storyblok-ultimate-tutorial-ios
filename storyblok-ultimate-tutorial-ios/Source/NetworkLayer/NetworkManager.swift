//
//  NetworkManager.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 14.01.25.
//

import Foundation
import Combine

/// A class that manages network requests.
final class NetworkManager {
    
    // MARK: - Properties
    private let session: URLSession
    
    // MARK: - Initializer
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Methods
    
    /**
     Fetches data from the given URL path.
     
     - Parameter path: The URL path to fetch data from.
     - Parameter method: The HTTP method to use for the request.
     - Parameter parameters: The parameters to include in the request.
     - Returns: A publisher with the fetched data or a network error.
     */
    func fetchData(from path: String, method: HTTPMethod = .GET, parameters: [String: String] = [:]) -> AnyPublisher<Data, NetworkError> {
        guard var url = URL(string: APIConstants.baseURL + path) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        if !parameters.isEmpty {
            guard let updatedURL = url.appendingQueryParameters(parameters) else {
                return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
            }
            url = updatedURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return session.dataTaskPublisher(for: request)
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
     Fetches data from the given URL path and decodes it into the specified type.
     
     - Parameter path: The URL path to fetch data from.
     - Parameter method: The HTTP method to use for the request.
     - Parameter parameters: The parameters to include in the request.
     - Parameter type: The type to decode the fetched data into.
     - Returns: A publisher with the fetched and decoded data or a network error.
     */
    func fetchData<T: Codable>(from path: String, method: HTTPMethod = .GET, parameters: [String: String] = [:], type: T.Type) -> AnyPublisher<T, NetworkError> {
        return fetchData(from: path, method: method, parameters: parameters)
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
