//
//  Story.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 15.01.25.
//


/// Represents the response structure from the Storyblok API for a single story.
struct StoryResponse: Codable {
    /// The primary story content.
    let story: Story
    
    /// A unique cache version identifier used to handle content versioning.
    let cv: Int
    
    /// Array of relational objects used for resolving references in the story.
    let rels: [Relation]
}


/// Represents a single story retrieved from the Storyblok API.
struct Story: Codable {
    /// The unique identifier of the story.
    let uuid: String
    
    /// The name of the story.
    let name: String
    
    /// The dynamic content of the story.
    /// This structure can handle various types of content blocks dynamically.
    let content: Content
    
    /// The slug of the story, representing its relative path.
    let slug: String
    
    /// The full slug (absolute path) of the story.
    let fullSlug: String
    
    /// The creation date of the story in ISO 8601 format.
    let createdAt: String
    
    /// The publication date of the story in ISO 8601 format.
    let publishedAt: String
    
    /// The last update date of the story in ISO 8601 format.
    let updatedAt: String
    
    /// Maps coding keys to match the JSON structure returned by the API.
    private enum CodingKeys: String, CodingKey {
        case uuid, name, content, slug
        case fullSlug = "full_slug"
        case createdAt = "created_at"
        case publishedAt = "published_at"
        case updatedAt = "updated_at"
    }
}


/// Represents a relational object used to resolve references in stories.
struct Relation: Codable {
    /// The unique identifier of the referenced object.
    let uuid: String
    
    /// The dynamic content associated with the referenced object.
    let content: [String: ContentValue]
    
    /// The slug (path) of the referenced object.
    let fullSlug: String

    /// Maps coding keys to match the JSON structure returned by the API.
    private enum CodingKeys: String, CodingKey {
        case uuid, content
        case fullSlug = "slug"
    }
}


/// Represents the response structure from the Storyblok API for multiple stories.
struct MultipleStoriesResponse: Codable {
    /// An array of stories retrieved from the API.
    let stories: [Story]
    
    /// A unique cache version identifier used to handle content versioning.
    let cv: Int
    
    /// Array of relational objects used for resolving references in the stories.
    let rels: [Relation]
}
