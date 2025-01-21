//
//  NetworkError.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 14.01.25.
//
//
//  This file defines an enumeration of network errors for handling common issues during API requests.
//  It provides descriptive error messages to improve debugging and error reporting.
//

import Foundation

/// An enumeration of network errors that can occur during API interactions.
/// Conforms to the `Error` and `LocalizedError` protocols for integration with Swift's error handling mechanisms.
///
/// Source: https://www.storyblok.com/docs/api/content-delivery/v2/getting-started/errors
///
enum NetworkError: Error, LocalizedError {
    
    // MARK: - Error Cases
    
    /// Indicates that the provided URL is invalid.
    case invalidURL
    
    /// Indicates that the request failed due to an underlying error.
    case requestFailed(Error)
    
    /// Indicates that the request is unauthorized (e.g., invalid or missing API key).
    case unauthorized
    
    /// Indicates that the requested resource could not be found.
    case notFound
    
    /// Indicates that the request format or parameters are invalid.
    case badRequest
    
    /// Indicates that the request contains invalid or unprocessable data.
    case unprocessableEntity
    
    /// Indicates that the client has exceeded the rate limit for API requests.
    case tooManyRequests
    
    /// Indicates that a server-side error occurred.
    case serverError
    
    /// Indicates that the API response is invalid or unexpected.
    case invalidResponse
    
    /// Indicates that decoding the response into the expected model failed.
    case decodingFailed(Error)
    
    // MARK: - Computed Properties
    
    /// A user-friendly description of the error.
    /// This property provides detailed information about the error to help with debugging and user feedback.
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid. Please check the URL format."
        case .requestFailed(let error):
            return "The request failed due to an error: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized access. Please verify your API key or authentication credentials."
        case .notFound:
            return "The requested resource could not be found. It may not exist or be published."
        case .badRequest:
            return "Bad request. Please ensure all required parameters and formats are correct."
        case .unprocessableEntity:
            return "The request contains invalid data and cannot be processed."
        case .tooManyRequests:
            return "You have exceeded the rate limit for API requests. Please slow down."
        case .serverError:
            return "A server error occurred. Please try again later."
        case .invalidResponse:
            return "The server returned an invalid or unexpected response."
        case .decodingFailed(let error):
            return "Failed to decode the response. Error: \(error.localizedDescription)"
        }
    }
}
