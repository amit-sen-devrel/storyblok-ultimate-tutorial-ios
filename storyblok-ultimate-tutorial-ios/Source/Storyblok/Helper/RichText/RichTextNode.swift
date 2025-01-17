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
    case bulletList = "bullet_list"
    case listItem = "list_item"
    case hardBreak = "hard_break"
}

enum RichTextMark: String, Codable {
    case bold
}

struct RichTextNode: Codable, Identifiable {
    var id = UUID() // Ensures a unique identifier
    let type: RichTextType
    let content: [RichTextNode]?
    let text: String?
    let marks: [RichTextMark]?
}


enum RichTextChunk {
    case paragraph(String) // Plain paragraph text
    case text(String, marks: [RichTextMark]) // Inline text with optional marks
    case orderedList([OrderedListItem]) // Ordered list with nested items
    case hardBreak // Line break

    struct OrderedListItem {
        let order: Int // Item number in the list
        let content: [RichTextChunk] // Nested content for the list item
    }
}
