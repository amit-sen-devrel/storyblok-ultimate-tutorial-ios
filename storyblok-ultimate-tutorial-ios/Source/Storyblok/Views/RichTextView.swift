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
            renderOrderedList(node)
        case .listItem:
            renderListItem(node)
        case .text:
            renderText(node)
        case .hardBreak:
            renderHardBreak()
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
    
    private func renderOrderedList(_ node: RichTextNode) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let items = node.content {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    HStack(alignment: .top, spacing: 8) {
                        Text("\(index + 1).")
                            .bold()
                        RichTextView(nodes: item.content ?? [])
                    }
                }
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
}
