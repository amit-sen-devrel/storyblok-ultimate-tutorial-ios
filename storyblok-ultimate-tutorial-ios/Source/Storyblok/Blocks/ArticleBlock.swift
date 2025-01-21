//
//  ArticleBlock.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


/// A model representing an article block with its key attributes.
struct ArticleBlock {
    /// The title of the article.
    let title: String
    
    /// A brief teaser or description for the article.
    let teaser: String
    
    /// An optional image associated with the article.
    let image: Asset?
    
    /// The rich text content of the article, parsed into nodes for structured rendering.
    let richContent: [RichTextNode]?
}
