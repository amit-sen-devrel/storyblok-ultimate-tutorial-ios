//
//  BlockRegistry.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 23.01.25.
//


import SwiftUI

final class BlockRegistry {
    static let shared = BlockRegistry()
    
    private var registry: [String: (RelationResolvableBlock) -> AnyView?] = [:]
    
    private init() {}
    
    /// Register a block view for a specific component
    func registerBlock<T: RelationResolvableBlock>(for component: String, builder: @escaping (T) -> AnyView) {
        registry[component] = { block in
            guard let castedBlock = block as? T else {
                print("Failed to cast block for component: \(component)")
                return nil
            }
            return builder(castedBlock)
        }
    }
    
    /// Get the block view for a specific component
    func getBlockView(for component: String, using block: RelationResolvableBlock) -> AnyView? {
        return registry[component]?(block)
    }
}
