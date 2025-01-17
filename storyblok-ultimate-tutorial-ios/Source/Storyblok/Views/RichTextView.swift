//
//  RichTextView.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import SwiftUI

struct RichTextView: ViewComponent {
    let nodes: [RichTextNode]
    
    var bodyContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(nodes.enumerated()), id: \.offset) { index, node in
                renderNode(node)
            }
        }
    }
    
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
            Divider()
        case .heading:
            renderHeading(node)
        }
    }
    
    private func renderParagraph(_ node: RichTextNode) -> some View {
        Group {
            if let content = node.content {
                Text(content.map { $0.text ?? "" }.joined())
                    .lineLimit(nil)
            } else {
                EmptyView()
            }
        }
    }
    
    private func renderListItem(_ node: RichTextNode) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let content = node.content {
                ForEach(content, id: \.id) { childNode in
                    renderNode(childNode)
                }
            }
        }
    }
    
    private func renderList(_ node: RichTextNode, isOrdered: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let items = node.content {
                ForEach(items.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: 8) {
                        if isOrdered {
                            Text("\(index + 1).").bold()
                        } else {
                            Text("•").bold() // Bullet for unordered list
                        }
                        renderNode(items[index])
                    }
                }
            }
        }
    }
    
    private func renderText(_ node: RichTextNode) -> some View {
        var text = Text(node.text ?? "")
        if let marks = node.marks, marks.contains(.bold) {
            text = text.bold()
        }
        return text
    }
    
    private func renderHardBreak() -> some View {
        Text("\n")
    }
    
    private func renderHeading(_ node: RichTextNode) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if let content = node.content {
                let level = node.attrs?["level"]?.toInt() ?? 1
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
