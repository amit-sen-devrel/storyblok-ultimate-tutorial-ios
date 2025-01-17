//
//  ContentValue.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 15.01.25.
//

import Foundation

public enum ContentValue: Codable {
    case string(String)
    case dictionary([String: ContentValue])
    case array([ContentValue])
    case int(Int)
    case double(Double)
    case bool(Bool)
    case null
    
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

extension ContentValue {
    func toString() -> String? {
        if case let .string(value) = self { return value }
        return nil
    }
    
    func toAsset() -> Asset? {
        if case let .dictionary(value) = self {
            do {
                let data = try JSONEncoder().encode(value)
                return try? JSONDecoder().decode(Asset.self, from: data)
            } catch {
                print("Error decoding Block: \(error)")
                return nil
            }
            
        }
        return nil
    }
    
    func toDictionary() -> [String: ContentValue]? {
        if case let .dictionary(value) = self { return value }
        return nil
    }
    
    func toArray() -> [ContentValue]? {
        if case let .array(value) = self { return value }
        return nil
    }
    
    func toBlock() -> Block? {
        if case let .dictionary(value) = self {
            do {
                let data = try JSONEncoder().encode(value) // Encode to JSON data
                return try JSONDecoder().decode(Block.self, from: data) // Decode directly into Block
            } catch {
                print("Error decoding Block: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func toRichText() -> [RichTextNode]? {
            // Ensure the top-level structure is a dictionary with "type: doc"
            if case let .dictionary(value) = self,
               value["type"]?.toString() == "doc",
               let contentArray = value["content"]?.toArray() {
                // Parse the "content" array recursively
                return RichTextParser.parse(content: contentArray)
            }
            return nil
        }
}
