//
//  ContentValue.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 15.01.25.
//

import Foundation

/// A flexible enum representing different types of content values.
/// This structure supports various data types, enabling dynamic handling of API responses.
public enum ContentValue: Codable {
    case string(String)
    case dictionary([String: ContentValue])
    case array([ContentValue])
    case int(Int)
    case double(Double)
    case bool(Bool)
    case null
    
    // MARK: - Initialization
    
    /// Initializes a `ContentValue` instance by decoding a value from the given decoder.
    ///
    /// This initializer dynamically determines the type of the content (e.g., `String`, `Int`, `Dictionary`)
    /// and creates the corresponding case.
    ///
    /// - Parameter decoder: The decoder to decode the value from.
    /// - Throws: A decoding error if the type is unsupported.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let dictionary = try? container.decode([String: ContentValue].self) {
            self = .dictionary(dictionary)
        } else if let array = try? container.decode([ContentValue].self) {
            self = .array(array)
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let double = try? container.decode(Double.self) {
            self = .double(double)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.typeMismatch(ContentValue.self, DecodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "Unsupported type"
            ))
        }
    }
    
    // MARK: - Encoding
    
    /// Encodes the `ContentValue` instance into the given encoder.
    ///
    /// - Parameter encoder: The encoder to encode the value into.
    /// - Throws: An encoding error if the value cannot be encoded.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .dictionary(let value):
            try container.encode(value)
        case .array(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}

// MARK: - Extensions for Type Conversion

extension ContentValue {
    
    /// Converts the `ContentValue` to a `String` if possible.
    func toString() -> String? {
        if case let .string(value) = self { return value }
        return nil
    }
    
    /// Converts the `ContentValue` to an `Int` if possible.
    ///
    /// This method also attempts to convert a `String` to an `Int` if the string contains a valid number.
    func toInt() -> Int? {
        if case let .int(value) = self {
            return value
        } else if case let .string(value) = self, let intValue = Int(value) {
            return intValue
        }
        return nil
    }
    
    /// Converts the `ContentValue` to an `Asset` if possible.
    ///
    /// This method attempts to decode the dictionary representation into an `Asset`.
    func toAsset() -> Asset? {
        if case let .dictionary(value) = self {
            do {
                let data = try JSONEncoder().encode(value) // Encode the dictionary to JSON data
                return try JSONDecoder().decode(Asset.self, from: data) // Decode JSON data into an Asset
            } catch {
                print("Error decoding Asset: \(error)")
                return nil
            }
        }
        return nil
    }
    
    /// Converts the `ContentValue` to a dictionary of `ContentValue`.
    func toDictionary() -> [String: ContentValue]? {
        if case let .dictionary(value) = self { return value }
        return nil
    }
    
    /// Converts the `ContentValue` to an array of `ContentValue`.
    func toArray() -> [ContentValue]? {
        if case let .array(value) = self { return value }
        return nil
    }
    
    /// Converts the `ContentValue` to a `Block` if possible.
    ///
    /// This method decodes the dictionary representation into a `Block`.
    func toBlock() -> Block? {
        if case let .dictionary(value) = self {
            do {
                let data = try JSONEncoder().encode(value) // Encode the dictionary to JSON data
                return try JSONDecoder().decode(Block.self, from: data) // Decode JSON data into a Block
            } catch {
                print("Error decoding Block: \(error)")
                return nil
            }
        }
        return nil
    }
    
    /// Converts the `ContentValue` to a rich text node array (`[RichTextNode]`) if possible.
    ///
    /// This method parses the "content" field recursively to construct a tree of `RichTextNode`s.
    func toRichText() -> [RichTextNode]? {
        if case let .dictionary(value) = self,
           value["type"]?.toString() == "doc",
           let contentArray = value["content"]?.toArray() {
            return RichTextParser.parse(content: contentArray)
        }
        return nil
    }
}
