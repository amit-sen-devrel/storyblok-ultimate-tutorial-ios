//
//  StoryRelationResolver.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import Foundation

/// A class responsible for resolving UUID references in story content to their actual data.
/// This enables the replacement of UUID references in story content with full relational data,
/// including top-level fields like `full_slug`.
final class StoryRelationResolver {
    
    // MARK: - Properties
    
    /// A dictionary for efficient lookup of relation data, where the keys are UUIDs, and the values are `Relation` objects.
    private let relsDictionary: [String: Relation]
    
    // MARK: - Initializer
    
    /**
     Initializes the `StoryRelationResolver` with an array of `Relation` objects to map UUID references to full content data.
     
     This setup transforms the provided array of `Relation` objects into a dictionary, with each UUID as a key
     and the associated `Relation` object as the value. The dictionary enables efficient lookups during content resolution.
     
     - Parameter relations: An array of `Relation` objects, each containing a UUID and associated content.
     
     ### Example
     ```swift
     let relations: [Relation] = [
         Relation(uuid: "123-abc", content: ["title": .string("Sample Title")], fullSlug: "sample-title"),
         Relation(uuid: "456-def", content: ["author": .string("John Doe")], fullSlug: "john-doe")
     ]
     let resolver = StoryRelationResolver(relations)
     ```
     */
    init(_ relations: [Relation]) {
        self.relsDictionary = Dictionary(uniqueKeysWithValues: relations.map { ($0.uuid, $0) })
    }
    
    // MARK: - Methods
    
    /**
     Resolves all UUID references in a given `Content` object, replacing each UUID with its corresponding content
     from the `relsDictionary`. It includes relational fields like `full_slug` at the top level.
     
     - Parameter content: The `Content` object containing fields with potential UUID references to resolve.
     - Returns: A new `Content` object where all UUID references have been replaced by their corresponding relational data.
     
     ### Example
     ```swift
     let content = Content(fields: ["author": .string("123-abc")])
     let resolvedContent = resolver.resolveContent(content)
     // The "author" field is replaced with the corresponding relation data.
     ```
     */
    func resolveContent(_ content: Content) -> Content {
        var newContentFields = content.fields
        
        for (key, value) in newContentFields {
            newContentFields[key] = resolveContentValue(value)
        }
        
        return Content(fields: newContentFields)
    }
    
    /**
     Recursively resolves a `ContentValue`, replacing any UUID references with their corresponding data from the `relsDictionary`.
     Top-level fields like `full_slug` are included in the resolved content.
     
     - Parameter value: The `ContentValue` to resolve, which may be a UUID string, dictionary, or array.
     - Returns: A fully resolved `ContentValue`, with UUID references replaced by corresponding data from `relsDictionary`.
     
     ### Details
     - If the `ContentValue` is a UUID string, it looks up the `relsDictionary` to find the associated `Relation` object.
     - For `dictionary` or `array` types, it recursively resolves all nested `ContentValue` items.
     - Scalar values (`int`, `double`, `bool`, `null`) are returned as-is.
     */
    func resolveContentValue(_ value: ContentValue) -> ContentValue {
        switch value {
        case .string(let uuid):
            // Check if the string is a UUID reference in the relations dictionary
            if let relation = relsDictionary[uuid] {
                // Include top-level fields such as `full_slug`
                var resolvedContent = relation.content
                resolvedContent["slug"] = .string(relation.fullSlug)
                
                // Recursively resolve nested content
                return .dictionary(resolvedContent.mapValues { resolveContentValue($0) })
            }
            // Return the original value if no match is found
            return value
            
        case .dictionary(let dict):
            // Recursively resolve each entry in the dictionary
            return .dictionary(dict.mapValues { resolveContentValue($0) })
            
        case .array(let array):
            // Recursively resolve each item in the array
            return .array(array.map { resolveContentValue($0) })
            
        case .int, .double, .bool, .null:
            // Return the value directly for scalar types that don't require resolution
            return value
        }
    }
}
