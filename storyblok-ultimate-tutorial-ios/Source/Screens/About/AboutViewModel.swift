//
//  AboutViewModel.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//


import Foundation
import Combine

final class AboutViewModel: ObservableObject {
    // MARK: - Properties
    private let storyFetcher: StoryFetcher
    private var cancellables = Set<AnyCancellable>()
    
    private let slug: String

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var richContent: [RichTextNode]? // Parsed rich text content

    // MARK: - Initializer
    init(storyFetcher: StoryFetcher, slug: String? = nil) {
        self.storyFetcher = storyFetcher
        self.slug = slug ?? ""
    }

    // MARK: - Fetch About Story
    func fetchAboutStory() {
        isLoading = true
        errorMessage = nil

        storyFetcher.fetchStory(slug: self.slug, resolveRelations: nil)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] storyResponse in
                guard let self = self else { return }

                // Extract rich text content
                if let body = storyResponse.story.content.fields["body"]?.toArray(),
                   let firstBlock = body.first?.toDictionary(),
                   let richTextContent = firstBlock["text"]?.toRichText() {
                    self.richContent = richTextContent
                } else {
                    self.richContent = nil
                }
            })
            .store(in: &cancellables)
    }
}
