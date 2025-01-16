//
//  RichTextNode.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import Foundation

enum RichTextType: String, Codable {
    case paragraph
    case text
    case orderedList = "ordered_list"
    case listItem = "list_item"
    case hardBreak = "hard_break"
}

enum RichTextMark: String, Codable {
    case bold
}

struct RichTextNode: Codable, Identifiable {
    var id = UUID() // Unique identifier for SwiftUI
    let type: RichTextType
    let content: [RichTextNode]?
    let text: String?
    let marks: [RichTextMark]?
}
