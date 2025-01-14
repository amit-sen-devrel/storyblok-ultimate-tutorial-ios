//
//  NetworkError.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 14.01.25.
//


import Foundation

/// An enumeration of network errors.
/// Source: https://www.storyblok.com/docs/api/content-delivery/v2/getting-started/errors
/// 
enum NetworkError: Error, LocalizedError {
    // MARK: - Cases
    
    /// The URL is invalid.
    case invalidURL
    
    /// The request failed.
    case requestFailed(Error)
    
    /// The request is unauthorized.
    case unauthorized
    
    /// The requested resource doesn't exist.
    case notFound
    
    /// The request is bad.
    case badRequest
    
    /// The request contains invalid data.
    case unprocessableEntity
    
    /// The rate limit has been exceeded.
    case tooManyRequests
    
    /// A server error occurred.
    case serverError
    
    /// The response is invalid.
    case invalidResponse
    
    /// Decoding the response failed
    case decodingFailed(Error)
    
    // MARK: - Computed Properties
    
    /// Returns the error description for each case
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed(let error):
            return "Request failed with error: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized: Please check your API key."
        case .notFound:
            return "Not Found: The requested resource doesn't exist."
        case .badRequest:
            return "Bad Request: Invalid format or missing parameters."
        case .unprocessableEntity:
            return "Unprocessable Entity: Request contains invalid data."
        case .tooManyRequests:
            return "Too Many Requests: You have exceeded the rate limit."
        case .serverError:
            return "Server Error: Something went wrong on the server."
        case .invalidResponse:
            return "Invalid Response: Unexpected response format."
        case .decodingFailed(let error):
            return "Decoding Failed: \(error.localizedDescription)"
        }
    }
}
