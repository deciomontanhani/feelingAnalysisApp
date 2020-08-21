final class TweetsListViewModel {

    private weak var controller: TweetsListViewControllerProtocol?
    private var repository: TweetsListRepositoryProtocol?
    private var coordinator: TweetsListCoordinatorProtocol?

    func set(coordinator: TweetsListCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    func set(controller: TweetsListViewControllerProtocol) {
        self.controller = controller
    }

    func set(repository: TweetsListRepositoryProtocol) {
        self.repository = repository
    }
}

extension TweetsListViewModel: TweetsListViewModelProtocol {
    func goBack() {
        coordinator?.goBack()
    }
}
