import UIKit

final class TweetAnalysisCoordinator {

    private let currentNavigationController: UINavigationController
    private let tweet: Tweet

    init(currentNavigationController: UINavigationController, tweet: Tweet) {
        self.currentNavigationController = currentNavigationController
        self.tweet = tweet
    }

    func start() {
        let viewController = TweetAnalysisViewController()
        let repository = TweetAnalysisRepository()
        let viewModel = TweetAnalysisViewModel(tweet: tweet)
        viewModel.set(controller: viewController)
        viewModel.set(repository: repository)
        viewModel.set(coordinator: self)
        viewController.set(viewModel: viewModel)
        currentNavigationController.pushViewController(viewController, animated: true)
    }
}

extension TweetAnalysisCoordinator: TweetAnalysisCoordinatorProtocol {
    func goBack() {
        currentNavigationController.popViewController(animated: true)
    }
}
