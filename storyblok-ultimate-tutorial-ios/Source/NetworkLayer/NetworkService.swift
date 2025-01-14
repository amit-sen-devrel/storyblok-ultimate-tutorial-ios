//
//  NetworkService.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 14.01.25.
//

import Foundation
import Combine

protocol NetworkService {
    func fetchData(from urlString: String) -> AnyPublisher<Data, NetworkError>
    func fetchDecodedData<T: Codable>(from urlString: String, type: T.Type) -> AnyPublisher<T, NetworkError>
}
