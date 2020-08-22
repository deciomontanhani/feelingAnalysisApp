final class TweetsListViewModel {

    private weak var controller: TweetsListViewControllerProtocol?
    private var repository: TweetsListRepositoryProtocol?
    private var coordinator: TweetsListCoordinatorProtocol?

    private var tweets = [Tweet]()
    private var currentSearch = ""
    private let maxResultsPerPage = 20
    private var nextPageToken: String? = nil
    private var isFetchInProgress = false

    func set(coordinator: TweetsListCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    func set(controller: TweetsListViewControllerProtocol) {
        self.controller = controller
    }

    func set(repository: TweetsListRepositoryProtocol) {
        self.repository = repository
    }

    private func setCurrentSearch(_ text: String) {
        if currentSearch == text {
            tweets = []
        }
        currentSearch = text
    }
}

extension TweetsListViewModel: TweetsListViewModelProtocol {
    func getTweetsCount() -> Int {
        return tweets.count
    }

    func getCurrentUser() -> String {
        return currentSearch
    }

    func getTweetModel(at index: Int) -> Tweet? {
        return tweets[optional: index]
    }

    func didTapTweet(at index: Int) {
        guard let tweet = tweets[optional: index] else { return }
        print("tweet clicado foi: \(tweet.text)")
    }

    func goBack() {
        coordinator?.goBack()
    }

    func searchProfile(_ user: String) {
        guard !isFetchInProgress else { return }
        setCurrentSearch(user)
        isFetchInProgress = true
        controller?.showLoading()
        repository?.getTweets(from: currentSearch,
                              nextPageToken: nextPageToken,
                              maxResults: maxResultsPerPage) { [weak self] result in
            self?.isFetchInProgress = false

            switch result {
            case .success(let response):
                if response.data.isEmpty {
                    self?.controller?.showError(message: "Não foi possível carregar informações desse usuário")
                    return
                }
                self?.tweets = response.data
                self?.controller?.reloadTable()
            case.failure(let error):
                self?.controller?.showError(message: error.localizedDescription)
                print(error)
            }
        }
    }

    func retrySearch() {
        searchProfile(currentSearch)
    }
}
