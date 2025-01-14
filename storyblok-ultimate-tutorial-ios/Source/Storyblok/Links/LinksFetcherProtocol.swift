//
//  LinksFetcherProtocol.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 14.01.25.
//


import Combine

protocol LinksFetcherProtocol {
    func fetchLinks() -> AnyPublisher<[String: Link], NetworkError>
}
