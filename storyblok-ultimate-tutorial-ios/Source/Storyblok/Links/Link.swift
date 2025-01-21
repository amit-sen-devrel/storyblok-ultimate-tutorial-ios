//
//  Link.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 14.01.25.
//


import Foundation

/// A response model for the `/links` endpoint of the Storyblok API.
/// This model represents the structure of the JSON response containing links data.
struct LinksResponse: Codable {
    /// A dictionary of links where the key is a unique identifier (String) and the value is a `Link` object.
    let links: [String: Link]
}

/// A model representing an individual link in the Storyblok system.
/// Links are used to define the structure of a project, including pages and folders.
struct Link: Codable {
    /// The unique numeric identifier of the link.
    let id: Int
    
    /// The universally unique identifier (UUID) of the link.
    let uuid: String
    
    /// The slug (URL segment) of the link.
    let slug: String
    
    /// The full path of the link, if available.
    let path: String?
    
    /// The parent ID of the link, if it is part of a folder structure.
    let parentID: Int?
    
    /// The display name of the link.
    let name: String
    
    /// A boolean indicating whether the link represents a folder.
    let isFolder: Bool
    
    /// A boolean indicating whether the link is published.
    let published: Bool
    
    /// A boolean indicating whether the link is the start page of the project.
    let isStartpage: Bool
    
    /// The position of the link in its parent structure, used for ordering.
    let position: Int
    
    /// The real path of the link, if it differs from the slug (optional).
    let realPath: String?
    
    /// Custom coding keys to map the API response fields to the Swift properties.
    private enum CodingKeys: String, CodingKey {
        case id, uuid, slug, path, name, position, published
        case parentID = "parent_id"
        case isFolder = "is_folder"
        case isStartpage = "is_startpage"
        case realPath = "real_path"
    }
}
