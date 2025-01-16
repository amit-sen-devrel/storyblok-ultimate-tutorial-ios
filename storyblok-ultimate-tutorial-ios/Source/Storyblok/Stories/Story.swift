//
//  Story.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 15.01.25.
//


struct StoryResponse: Codable {
    let story: Story
    let cv: Int
    let rels: [Relation]  // Add this for relation resolution
}


struct Story: Codable {
    let name: String
    let content: Content  // Replace `StoryContent` with `Content` for dynamic handling
    let slug: String
    let fullSlug: String
    let createdAt: String
    let publishedAt: String
    let updatedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case name, content, slug
        case fullSlug = "full_slug"
        case createdAt = "created_at"
        case publishedAt = "published_at"
        case updatedAt = "updated_at"
    }
}

struct Relation: Codable {
    let uuid: String
    let content: [String: ContentValue]
}
