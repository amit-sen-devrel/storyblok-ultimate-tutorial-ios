//
//  RichTextParser.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//

/// A utility class for parsing rich text content from Storyblok's API response.
struct RichTextParser {
    
    /**
     Parses a list of `ContentValue` items into an array of `RichTextNode` objects.
     
     - Parameter content: An array of `ContentValue` items representing the rich text structure.
     - Returns: An array of `RichTextNode` objects or `nil` if parsing fails.
     */
    static func parse(content: [ContentValue]) -> [RichTextNode]? {
        // Initialize an array to store parsed nodes
        var nodes: [RichTextNode] = []

        // Iterate over each content item
        for item in content {
            // Ensure the item is a dictionary
            if case let .dictionary(value) = item {
                // Decode the node type from the "type" field
                guard let typeString = value["type"]?.toString(),
                      let type = RichTextType(rawValue: typeString) else { continue }

                // Parse styling marks, if present
                let marks: [RichTextMark]? = {
                    if let marksArray = value["marks"]?.toArray() {
                        return marksArray.compactMap { markValue in
                            // Decode each mark into a `RichTextMark`
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

                // Parse attributes, if present (e.g., heading level)
                let attrs: [String: ContentValue]? = {
                    if let attributes = value["attrs"]?.toDictionary() {
                        return attributes
                    }
                    return nil
                }()

                // Recursively parse child content, if any
                let childContent = value["content"]?.toArray().flatMap(parse)

                // Create a `RichTextNode` with the parsed data
                let node = RichTextNode(
                    type: type,                // Type of the node (e.g., paragraph, heading)
                    content: childContent,     // Child nodes, if present
                    text: value["text"]?.toString(), // Text content, if applicable
                    marks: marks,              // Styling marks, if applicable
                    attrs: attrs               // Attributes, if applicable
                )
                nodes.append(node)
            }
        }

        return nodes
    }
}
