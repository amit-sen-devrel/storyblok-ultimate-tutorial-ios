//
//  Content.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 15.01.25.
//


struct Content: Codable {
    var fields: [String: ContentValue]
    
    public init(fields: [String: ContentValue]) {
        self.fields = fields
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var fields = [String: ContentValue]()
        
        for key in container.allKeys {
            let decodedValue = try container.decode(ContentValue.self, forKey: key)
            fields[key.stringValue] = decodedValue
        }
        
        self.fields = fields
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        for (key, value) in fields {
            guard let codingKey = DynamicCodingKeys(stringValue: key) else {
                throw EncodingError.invalidValue(key, EncodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Failed to create coding key for field: \(key)"
                ))
            }
            try container.encode(value, forKey: codingKey)
        }
    }
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) { self.stringValue = stringValue }
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
    }
}
