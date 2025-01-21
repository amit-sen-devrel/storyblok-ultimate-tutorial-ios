//
//  Content.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 15.01.25.
//


import Foundation

/// A generic container for dynamic content fields, supporting dynamic keys and values of type `ContentValue`.
struct Content: Codable {
    
    /// A dictionary that holds the dynamic content fields, with keys as field names and values as `ContentValue`.
    var fields: [String: ContentValue]
    
    // MARK: - Initializer
    
    /// Initializes a `Content` instance with the given fields.
    ///
    /// - Parameter fields: A dictionary of content fields.
    public init(fields: [String: ContentValue]) {
        self.fields = fields
    }
    
    // MARK: - Decoding
    
    /// Decodes a `Content` instance from a decoder, supporting dynamic keys.
    ///
    /// This initializer uses a custom `DynamicCodingKeys` struct to decode fields with keys that are not known at compile time.
    ///
    /// - Parameter decoder: The decoder used to decode the JSON data.
    /// - Throws: Throws a decoding error if decoding fails.
    public init(from decoder: Decoder) throws {
        // Create a keyed container with dynamic coding keys
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var fields = [String: ContentValue]()
        
        // Iterate through all dynamic keys and decode their values
        for key in container.allKeys {
            let decodedValue = try container.decode(ContentValue.self, forKey: key)
            fields[key.stringValue] = decodedValue
        }
        
        self.fields = fields
    }
    
    // MARK: - Encoding
    
    /// Encodes a `Content` instance to an encoder, supporting dynamic keys.
    ///
    /// This method uses the `DynamicCodingKeys` struct to encode fields with keys that are not known at compile time.
    ///
    /// - Parameter encoder: The encoder used to encode the data.
    /// - Throws: Throws an encoding error if encoding fails.
    public func encode(to encoder: Encoder) throws {
        // Create a keyed container with dynamic coding keys
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        
        // Iterate through all fields and encode their values
        for (key, value) in fields {
            guard let codingKey = DynamicCodingKeys(stringValue: key) else {
                throw EncodingError.invalidValue(key, EncodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Failed to create coding key for field: \(key)"
                ))
            }
            try container.encode(value, forKey: codingKey)
        }
    }
    
    // MARK: - Dynamic Coding Keys
    
    /// A dynamic implementation of the `CodingKey` protocol for handling unknown keys.
    private struct DynamicCodingKeys: CodingKey {
        
        /// The string value of the key.
        var stringValue: String
        
        /// Creates a new instance with the given string value.
        /// - Parameter stringValue: The string value for the coding key.
        init?(stringValue: String) { self.stringValue = stringValue }
        
        /// The integer value of the key (unsupported for dynamic keys).
        var intValue: Int? { return nil }
        
        /// Creates a new instance with the given integer value (unsupported for dynamic keys).
        /// - Parameter intValue: The integer value for the coding key.
        init?(intValue: Int) { return nil }
    }
}
