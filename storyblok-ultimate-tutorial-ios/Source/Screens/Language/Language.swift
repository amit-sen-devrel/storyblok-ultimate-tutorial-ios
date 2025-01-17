//
//  Language.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//

import Foundation

struct Language: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let code: String?
    let flag: String
}

extension Language {
    static let english: Language = .init(name: "English", code: nil, flag: "🇬🇧")
    static let german: Language = .init(name: "German", code: "de", flag: "🇩🇪")
}
