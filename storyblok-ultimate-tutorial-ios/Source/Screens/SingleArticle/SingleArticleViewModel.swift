//
//  SingleArticleViewModel.swift
//  storyblok-ultimate-tutorial-ios
//
//  Created by Amit Sen on 16.01.25.
//


import Combine

final class SingleArticleViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var articleBlock: ArticleBlock?

    private let fullSlug: String
    private let storyFetcher: StoryFetcher
    private var cancellables = Set<AnyCancellable>()

    init(fullSlug: String, storyFetcher: StoryFetcher) {
        self.fullSlug = fullSlug
        self.storyFetcher = storyFetcher
    }

    func fetchArticle() {
        isLoading = true
        errorMessage = nil

        storyFetcher.fetchStory(slug: fullSlug)
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
                self.articleBlock = ArticleBlock(
                    title: storyResponse.story.content.fields["title"]?.toString() ?? "",
                    teaser: storyResponse.story.content.fields["teaser"]?.toString() ?? "",
                    image: storyResponse.story.content.fields["image"]?.toAsset(),
                    richContent: storyResponse.story.content.fields["content"]?.toRichText()
                )
            })
            .store(in: &cancellables)
    }
}
