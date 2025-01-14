//
//  URL+Params.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 14.01.25.
//

import Foundation

extension URL {
    func appendingQueryParameters(_ parameters: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components?.url
    }
}
