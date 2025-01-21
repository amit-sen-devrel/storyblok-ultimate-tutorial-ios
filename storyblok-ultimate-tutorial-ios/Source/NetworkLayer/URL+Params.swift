//
//  URL+Params.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 14.01.25.
//
//
//  This extension provides a utility to append query parameters to a URL.
//

import Foundation

extension URL {
    
    /**
     Appends query parameters to the URL.
     
     - Parameter parameters: A dictionary containing key-value pairs of query parameters to append.
     - Returns: A new `URL` with the appended query parameters, or `nil` if the URL could not be constructed.
     
     ### Usage Example
     ```swift
     let baseURL = URL(string: "https://api.example.com/resource")
     let parameters = ["key1": "value1", "key2": "value2"]
     if let urlWithParameters = baseURL?.appendingQueryParameters(parameters) {
         print(urlWithParameters)
         // Output: https://api.example.com/resource?key1=value1&key2=value2
     }
     ```
     */
    func appendingQueryParameters(_ parameters: [String: String]) -> URL? {
        // Resolve the base URL into components
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        
        // Map the parameters dictionary to URLQueryItem array
        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        // Return the updated URL
        return components?.url
    }
}
