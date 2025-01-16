//
//  HeroBlock.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 15.01.25.
//


struct HeroBlock: Codable {
    let _uid: String
    let layout: String
    let headline: String
    let subheadline: String?
    let backgroundImage: Asset?
    let component: String
    
    private enum CodingKeys: String, CodingKey {
        case _uid, layout, headline, subheadline, component
        case backgroundImage = "background_image"
    }
}
