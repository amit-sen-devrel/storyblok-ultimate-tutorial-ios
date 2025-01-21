//
//  RichTextView.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import SwiftUI

/// A SwiftUI view for rendering rich text content based on an array of `RichTextNode`.
///
/// This view supports multiple types of rich text elements, including paragraphs, headings,
/// ordered and unordered lists, list items, horizontal rules, and styled text nodes.
struct RichTextView: ViewComponent {
    /// An array of rich text nodes to render.
    let nodes: [RichTextNode]
    
    /// The main content of the rich text view.
    var bodyContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Iterate over the nodes and render each one
            ForEach(Array(nodes.enumerated()), id: \.offset) { index, node in
                renderNode(node)
            }
        }
    }
    
    /// Renders a rich text node based on its type.
    /// - Parameter node: The rich text node to render.
    @ViewBuilder
    private func renderNode(_ node: RichTextNode) -> some View {
        switch node.type {
        case .paragraph:
            renderParagraph(node)
        case .orderedList:
            renderList(node, isOrdered: true)
        case .bulletList:
            renderList(node, isOrdered: false)
        case .listItem:
            renderListItem(node)
        case .text:
            renderText(node)
        case .hardBreak:
            renderHardBreak()
        case .horizontalRule:
            Divider() // Render a horizontal rule
        case .heading:
            renderHeading(node)
        }
    }
    
    /// Renders a paragraph node.
    /// - Parameter node: The rich text node representing a paragraph.
    private func renderParagraph(_ node: RichTextNode) -> some View {
        Group {
            if let content = node.content {
                Text(content.map { $0.text ?? "" }.joined())
                    .lineLimit(nil)
            } else {
                EmptyView() // If no content, render nothing
            }
        }
    }
    
    /// Renders a list item node.
    /// - Parameter node: The rich text node representing a list item.
    private func renderListItem(_ node: RichTextNode) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let content = node.content {
                ForEach(content, id: \.id) { childNode in
                    renderNode(childNode)
                }
            }
        }
    }
    
    /// Renders a list node (ordered or unordered).
    /// - Parameters:
    ///   - node: The rich text node representing the list.
    ///   - isOrdered: A flag indicating whether the list is ordered or unordered.
    private func renderList(_ node: RichTextNode, isOrdered: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let items = node.content {
                ForEach(items.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: 8) {
                        if isOrdered {
                            Text("\(index + 1).").bold() // Ordered list numbering
                        } else {
                            Text("•").bold() // Unordered list bullet
                        }
                        renderNode(items[index])
                    }
                }
            }
        }
    }
    
    /// Renders a text node.
    /// - Parameter node: The rich text node representing styled text.
    private func renderText(_ node: RichTextNode) -> some View {
        var text = Text(node.text ?? "")
        if let marks = node.marks, marks.contains(.bold) {
            text = text.bold() // Apply bold style if specified
        }
        return text
    }
    
    /// Renders a hard break node (line break).
    private func renderHardBreak() -> some View {
        Text("\n") // Add a new line
    }
    
    /// Renders a heading node with varying font sizes and styles based on its level.
    /// - Parameter node: The rich text node representing a heading.
    private func renderHeading(_ node: RichTextNode) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if let content = node.content {
                let level = node.attrs?["level"]?.toInt() ?? 1 // Default to level 1 if not specified
                let text = Text(content.compactMap { $0.text }.joined())
                switch level {
                case 1:
                    text.font(.largeTitle).fontWeight(.bold)
                case 2:
                    text.font(.title).fontWeight(.bold)
                case 3:
                    text.font(.title3).fontWeight(.semibold)
                default:
                    text.font(.body).fontWeight(.regular)
                }
            }
        }
    }
}
