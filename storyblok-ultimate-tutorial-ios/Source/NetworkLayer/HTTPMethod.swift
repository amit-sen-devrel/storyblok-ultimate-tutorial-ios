//
//  HTTPMethod.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 14.01.25.
//
//
//  This file defines an enumeration for HTTP methods used in API requests.
//  It simplifies the process of specifying request methods and ensures type safety.
//

/// An enumeration representing the HTTP methods used in API requests.
/// This enum ensures type safety and consistency when specifying HTTP methods in network operations.
///
/// - Usage Example:
/// ```
/// let method: HTTPMethod = .GET
/// ```
enum HTTPMethod: String {
    /// The `GET` method requests data from a server.
    case GET = "GET"
    
    /// The `POST` method submits data to be processed by a server.
    case POST = "POST"
    
    /// The `PUT` method updates or replaces existing data on a server.
    case PUT = "PUT"
    
    /// The `DELETE` method deletes existing data from a server.
    case DELETE = "DELETE"
}
