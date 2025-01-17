//
//  ArticlesViewModel.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 17.01.25.
//


import Foundation
import Combine

final class ArticlesViewModel: ObservableObject {
    let storyFetcher: StoryFetcher
    private var cancellables = Set<AnyCancellable>()

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var articleCards: [ArticleCard] = [] // Updated property to store ArticleCards

    // MARK: - Initializer
    init(storyFetcher: StoryFetcher) {
        self.storyFetcher = storyFetcher
    }

    // MARK: - Fetch All Articles
    func fetchAllArticles() {
        isLoading = true
        errorMessage = nil

        let params = [
            "starts_with": "blogs/",
            "is_startpage": "false"
        ]
        
        storyFetcher.fetchMultipleStories(resolveRelations: nil, params: params)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] storiesResponse in
                guard let self = self else { return }
                self.articleCards = storiesResponse.stories.compactMap { story in
                    ArticleCard(
                        uuid: story.uuid,
                        title: story.content.fields["title"]?.toString() ?? "No Title",
                        teaser: story.content.fields["teaser"]?.toString() ?? "",
                        image: story.content.fields["image"]?.toAsset(),
                        fullSlug: story.fullSlug
                    )
                }
            })
            .store(in: &cancellables)
    }
}
