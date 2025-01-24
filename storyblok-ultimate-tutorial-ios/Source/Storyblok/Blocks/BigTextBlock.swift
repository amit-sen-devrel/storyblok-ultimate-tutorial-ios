//
//  BigTextBlock.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 24.01.25.
//


import Foundation

/// Represents a "big_text" block containing rich text content.
struct BigTextBlock: RelationResolvableBlock {
    let _uid: String    // Unique identifier for the block
    let component: String // Component name (should be "big_text")
    let text: [RichTextNode]? // Parsed rich text content
    
    /// Custom decoding to parse `text` as `RichTextNode`
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _uid = try container.decode(String.self, forKey: ._uid)
        component = try container.decode(String.self, forKey: .component)
        if let contentValue = try? container.decode(ContentValue.self, forKey: .text) {
            text = contentValue.toRichText()
        } else {
            text = nil
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case _uid, component, text
    }
}
