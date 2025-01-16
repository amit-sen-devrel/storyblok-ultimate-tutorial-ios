//
//  StoryRelationResolver.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import Foundation

/// Class responsible for resolving UUID references in story content to actual data.
/// Takes an array of `Relation` objects and maps them into a dictionary for quick lookups,
/// replacing UUIDs with full content data within the `Content` structure.
final class StoryRelationResolver {
    
    /// Dictionary for efficient lookup of relation data, with UUIDs as keys
    private let relsDictionary: [String: [String: ContentValue]]
    
    /**
     Initializes the `StoryRelationResolver` with an array of `Relation` objects to map UUID references to full content data.
     
     This initializer transforms the provided array of `Relation` objects into a dictionary, with each UUID as a key and the associated content data as the value. The dictionary (`relsDictionary`) enables efficient lookups during content resolution, allowing UUIDs within the story content to be quickly replaced with their full data. This setup facilitates the seamless mapping of referenced data, particularly when stories have deeply nested or relational fields.
     
     - Parameter `relations`: An array of `Relation` objects, each containing a UUID and associated content to be mapped.
     
     ### Usage Example
     ```swift
     // Example `Relation` objects containing UUIDs and associated content
     let relation1 = Relation(uuid: "123-abc", content: ["author": .string("John Doe")])
     let relation2 = Relation(uuid: "456-def", content: ["title": .string("Sample Title")])
     
     // Initializing the resolver with the relations array
     let resolver = StoryRelationResolver([relation1, relation2])
     
     // `resolver` can now be used to resolve UUIDs within story content, replacing them with full content data
     ```
     */
    init(_ relations: [Relation]) {
        // Maps relations into a dictionary using UUID as the key for quick reference during resolution
        self.relsDictionary = Dictionary(uniqueKeysWithValues: relations.map { ($0.uuid, $0.content) })
    }
    
    /**
     Resolves all UUID references in a given `Content` object, replacing each UUID with its corresponding content from `relsDictionary`.
     
     This function iterates over each field in the provided `Content` object, checking for UUID references that need to be resolved. For each UUID found, it retrieves the associated full content from `relsDictionary` and replaces the UUID with that content. This method returns a new `Content` object with all relational UUID references resolved to their full data.
     
     - Parameter `content`: The `Content` object containing fields with possible UUID references to resolve.
     - Returns: A new `Content` object with all UUID references replaced by the full content values found in `relsDictionary`.
     
     ### Usage Example
     ```swift
     let resolver = StoryRelationResolver(["blog-list.blogs", "blog-post.author"])
     let resolvedContent = resolver.resolveContent(someContentObject)
     ```
     */
    func resolveContent(_ content: Content) -> Content {
        // Copy of content fields to store resolved values
        var newContentFields = content.fields
        
        // Iterate over each field and resolve any UUID references
        for (key, value) in newContentFields {
            newContentFields[key] = resolveContentValue(value)
        }
        
        return Content(fields: newContentFields)
    }
    
    /**
     Recursively resolves a `ContentValue`, replacing any UUIDs with their corresponding full content data.
     
     This function checks the type of `ContentValue` to determine whether it’s a UUID reference (string), dictionary, or array.
     - For UUID strings, it looks up the UUID in `relsDictionary` and replaces it with the associated content if found, recursively resolving any nested references within that content.
     - For dictionaries and arrays, it recursively resolves any nested `ContentValue` items within them, ensuring all levels of the structure are fully resolved.
     
     - Parameter `value`: The `ContentValue` to resolve, which could be a UUID string, dictionary, or array.
     - Returns: A fully resolved `ContentValue`, with UUID references replaced by actual content where applicable.
     */
    func resolveContentValue(_ value: ContentValue) -> ContentValue {
        switch value {
        case .string(let uuid):
            // Checks if the string is a UUID reference in relsDictionary and replaces it with the actual content
            if let resolvedContent = relsDictionary[uuid] {
                // Recursively resolves any nested content within the dictionary
                return .dictionary(resolvedContent.mapValues { resolveContentValue($0) })
            }
            
            // Returns the original value if no resolution is found
            return value
            
        case .dictionary(let dict):
            // Recursively resolve each entry in the dictionary
            return .dictionary(dict.mapValues { resolveContentValue($0) })
            
        case .array(let array):
            // Recursively resolve each item in the array
            return .array(array.map { resolveContentValue($0) })
            
        case .int, .double, .bool, .null:
            // Return the value directly for types that don’t require resolution
            return value
        }
    }

}
