//
//  RichTextNode.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import Foundation

/// Represents the type of a rich text node.
enum RichTextType: String, Codable {
    /// A paragraph of text.
    case paragraph
    
    /// A plain text node.
    case text
    
    /// An ordered list (numbered).
    case orderedList = "ordered_list"
    
    /// A bullet list (unordered).
    case bulletList = "bullet_list"
    
    /// A list item within an ordered or bullet list.
    case listItem = "list_item"
    
    /// A hard line break.
    case hardBreak = "hard_break"
    
    /// A horizontal rule (divider).
    case horizontalRule = "horizontal_rule"
    
    /// A heading (e.g., H1, H2, H3).
    case heading
}


/// Represents a styling mark (e.g., bold, italic) applied to a rich text node.
enum RichTextMark: String, Codable {
    /// Bold text styling.
    case bold
}


/// Represents a node in a rich text structure, supporting hierarchical content.
struct RichTextNode: Codable, Identifiable {
    /// Unique identifier for the node (used for SwiftUI rendering).
    var id = UUID()
    
    /// The type of the rich text node (e.g., paragraph, heading, list item).
    let type: RichTextType
    
    /// The child nodes of this node, if any.
    /// - Example: A list node contains `listItem` nodes as children.
    let content: [RichTextNode]?
    
    /// The plain text content of the node, if applicable.
    /// - Example: A `text` node would use this field to store its value.
    let text: String?
    
    /// The styling marks applied to this node, if any (e.g., bold, italic).
    /// - Example: A `text` node may have a `bold` mark.
    let marks: [RichTextMark]?
    
    /// Attributes for specific node types (e.g., heading level, list attributes).
    /// - Example: A `heading` node may have an attribute for its level (H1, H2, etc.).
    let attrs: [String: ContentValue]?
}
