//
//  RichTextParser.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


struct RichTextParser {
    static func parse(content: [ContentValue]) -> [RichTextNode]? {
        var nodes: [RichTextNode] = []

        for item in content {
            if case let .dictionary(value) = item {
                // Decode the node type
                guard let typeString = value["type"]?.toString(),
                      let type = RichTextType(rawValue: typeString) else { continue }

                // Parse the marks, if available
                let marks: [RichTextMark]? = {
                    if let marksArray = value["marks"]?.toArray() {
                        return marksArray.compactMap { markValue in
                            if case let .dictionary(markDict) = markValue,
                               let markType = markDict["type"]?.toString(),
                               let richTextMark = RichTextMark(rawValue: markType) {
                                return richTextMark
                            }
                            return nil
                        }
                    }
                    return nil
                }()

                // Parse the child content recursively
                let childContent = value["content"]?.toArray().flatMap(parse)

                // Create a RichTextNode
                let node = RichTextNode(
                    type: type,
                    content: childContent,
                    text: value["text"]?.toString(),
                    marks: marks
                )
                nodes.append(node)
            }
        }

        return nodes
    }
}
