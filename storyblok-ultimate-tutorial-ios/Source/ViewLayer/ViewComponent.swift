//
//  ViewComponent.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//

import SwiftUI

/// A protocol for lightweight, reusable SwiftUI views.
protocol ViewComponent: View {
    associatedtype Content: View
    
    /// The content of the view.
    @ViewBuilder var bodyContent: Content { get }
}

extension ViewComponent {
    var body: some View {
        bodyContent
    }
}
