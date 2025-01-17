//
//  StoryRelationResolver.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import Foundation

/// Class responsible for resolving UUID references in story content to actual data.
final class StoryRelationResolver {
    
    /// Dictionary for efficient lookup of relation data, with UUIDs as keys
    private let relsDictionary: [String: Relation]
    
    /**
     Initializes the `StoryRelationResolver` with an array of `Relation` objects to map UUID references to full content data.
     
     This initializer transforms the provided array of `Relation` objects into a dictionary, with each UUID as the key and the associated `Relation` object as the value.
     
     - Parameter `relations`: An array of `Relation` objects, each containing a UUID and associated content to be mapped.
     */
    init(_ relations: [Relation]) {
        self.relsDictionary = Dictionary(uniqueKeysWithValues: relations.map { ($0.uuid, $0) })
    }
    
    /**
     Resolves all UUID references in a given `Content` object, replacing each UUID with its corresponding content from `relsDictionary`.
     
     - Parameter `content`: The `Content` object containing fields with possible UUID references to resolve.
     - Returns: A new `Content` object with all relational UUID references replaced to include top-level fields (e.g., `full_slug`) where applicable.
     */
    func resolveContent(_ content: Content) -> Content {
        var newContentFields = content.fields
        for (key, value) in newContentFields {
            newContentFields[key] = resolveContentValue(value)
        }
        return Content(fields: newContentFields)
    }
    
    /**
     Resolves a UUID reference, replacing it with its corresponding `Relation` object including top-level fields.
     
     - Parameter value: The `ContentValue` to resolve.
     - Returns: A fully resolved `ContentValue`, with UUID references replaced by corresponding data from `relsDictionary`.
     */
    func resolveContentValue(_ value: ContentValue) -> ContentValue {
        switch value {
        case .string(let uuid):
            if let relation = relsDictionary[uuid] {
                // Include top-level fields (e.g., `full_slug`) in the resolved content
                var resolvedContent = relation.content
                resolvedContent["slug"] = .string(relation.fullSlug)
                return .dictionary(resolvedContent.mapValues { resolveContentValue($0) })
            }
            return value
            
        case .dictionary(let dict):
            return .dictionary(dict.mapValues { resolveContentValue($0) })
            
        case .array(let array):
            return .array(array.map { resolveContentValue($0) })
            
        case .int, .double, .bool, .null:
            return value
        }
    }
}
