
final class TweetAnalysisViewModel {

    private weak var controller: TweetAnalysisViewControllerProtocol?
    private var repository: TweetAnalysisRepositoryProtocol?
    private var coordinator: TweetAnalysisCoordinatorProtocol?

    private let tweet: Tweet

    init(tweet: Tweet) {
        self.tweet = tweet
    }

    func set(coordinator: TweetAnalysisCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    func set(controller: TweetAnalysisViewControllerProtocol) {
        self.controller = controller
    }

    func set(repository: TweetAnalysisRepositoryProtocol) {
        self.repository = repository
    }
}

extension TweetAnalysisViewModel: TweetAnalysisViewModelProtocol {
    func retry() {
        analyseTweet()
    }

    func didLoad() {
        analyseTweet()
    }
}

private extension TweetAnalysisViewModel {
    func analyseTweet() {
        let body = AnalysisObject(tweet: tweet.text)
        repository?.getAnalysis(from: body) { [weak self] result in
            switch result {
            case .success(let response):
                guard let score = response.documentSentiment?.score else {
                    self?.controller?.showError(message: "Não foi possível analisar esse Tweet.")
                    return
                }
                let feeling = FeelingType.getFeeling(score: score)
                self?.controller?.show(result: feeling.getDescription())
            case .failure(let error):
                self?.controller?.showError(message: error.localizedDescription)
            }
        }
    }
}
