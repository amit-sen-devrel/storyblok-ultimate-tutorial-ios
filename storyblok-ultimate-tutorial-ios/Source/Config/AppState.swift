//
//  AppState.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//


import Foundation
import Combine

final class AppState: ObservableObject {
    static let shared = AppState()
    
    private init() {}
    
    @Published var language: Language = .english // Default language
}
