//
//  RichTextParser.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import SwiftUI

struct RichTextParser {
    static func parse(content: [RichTextNode]) -> AnyView {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(content, id: \.id) { node in
                parseNode(node)
            }
        }
        .eraseToAnyView()
    }
    
    private static func parseNode(_ node: RichTextNode) -> AnyView {
        switch node.type {
        case .paragraph:
            return parseParagraph(node.content).eraseToAnyView()
        case .orderedList:
            return parseOrderedList(node.content).eraseToAnyView()
        case .listItem:
            return parseListItem(node.content).eraseToAnyView()
        case .text:
            return parseText(node).eraseToAnyView()
        case .hardBreak:
            return Text("\n").eraseToAnyView()
        }
    }
    
    private static func parseParagraph(_ content: [RichTextNode]?) -> AnyView {
        guard let content = content else { return EmptyView().eraseToAnyView() }
        return Text(content.map { $0.text ?? "" }.joined())
            .lineLimit(nil)
            .eraseToAnyView()
    }
    
    private static func parseOrderedList(_ content: [RichTextNode]?) -> AnyView {
        guard let content = content else { return EmptyView().eraseToAnyView() }
        return VStack(alignment: .leading, spacing: 4) {
            ForEach(Array(content.enumerated()), id: \.offset) { index, node in
                HStack(alignment: .top, spacing: 4) {
                    Text("\(index + 1).")
                        .bold()
                    parseNode(node)
                }
            }
        }
        .eraseToAnyView()
    }
    
    private static func parseListItem(_ content: [RichTextNode]?) -> AnyView {
        guard let content = content else { return EmptyView().eraseToAnyView() }
        return VStack(alignment: .leading, spacing: 4) {
            ForEach(content, id: \.id) { node in
                parseNode(node)
            }
        }
        .eraseToAnyView()
    }
    
    private static func parseText(_ node: RichTextNode) -> AnyView {
        var text = Text(node.text ?? "")
        if let marks = node.marks, marks.contains(.bold) {
            text = text.bold()
        }
        return text.eraseToAnyView()
    }
}

// Helper to erase to AnyView
extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
