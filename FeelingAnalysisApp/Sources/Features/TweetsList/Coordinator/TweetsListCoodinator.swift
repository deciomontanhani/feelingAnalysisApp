import UIKit

final class TweetsListCoordinator {

    private let currentNavigationController: UINavigationController

    init(currentNavigationController: UINavigationController) {
        self.currentNavigationController = currentNavigationController
    }

    func start() {
        let viewController = TweetsListViewController()
        let repository = TweetsListRepository()
        let viewModel = TweetsListViewModel()
        viewModel.set(controller: viewController)
        viewModel.set(repository: repository)
        viewModel.set(coordinator: self)
        viewController.set(viewModel: viewModel)
        currentNavigationController.pushViewController(viewController, animated: true)
    }
}

extension TweetsListCoordinator: TweetsListCoordinatorProtocol {
    func goToAnalysis(tweet: Tweet) {
        let coordinator =
            TweetAnalysisCoordinator(currentNavigationController: currentNavigationController,
                                     tweet: tweet)

        coordinator.start()
    }
}
