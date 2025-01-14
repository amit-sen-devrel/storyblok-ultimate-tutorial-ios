//
//  Link.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 14.01.25.
//


struct LinksResponse: Codable {
    let links: [String: Link]
}

/// Link model
struct Link: Codable {
    let id: Int
    let uuid: String
    let slug: String
    let path: String?
    let parentID: Int?
    let name: String
    let isFolder: Bool
    let published: Bool
    let isStartpage: Bool
    let position: Int
    let realPath: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, uuid, slug, path, name, position, published
        case parentID = "parent_id"
        case isFolder = "is_folder"
        case isStartpage = "is_startpage"
        case realPath = "real_path"
    }
}
