import UIKit

final class TweetsListViewController: UIViewController {

    private var viewModel: TweetsListViewModelProtocol?
    private lazy var customView: TweetsListViewProtocol = {
        let view = TweetsListView()
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FeelingsApp"
    }

    override func loadView() {
        view = customView
    }
}

extension TweetsListViewController: TweetsListViewControllerProtocol {
    func showError(message: String? = nil) {
        customView.showError(message: message)
    }

    func reloadTable() {
        customView.stopLoading()
        customView.reloadTable()
    }

    func showLoading() {
        customView.showLoading()
    }

    func set(viewModel: TweetsListViewModelProtocol) {
        self.viewModel = viewModel
    }
}

extension TweetsListViewController: TweetsListViewDelegate {
    func getTweetsCount() -> Int {
        viewModel?.getTweetsCount() ?? 0
    }

    func getTweetModel(at index: Int) -> Tweet? {
        viewModel?.getTweetModel(at: index)
    }

    func didTapTweet(at index: Int) {
        viewModel?.didTapTweet(at: index)
    }

    func searchProfile(_ user: String) {
        viewModel?.searchProfile(user)
    }

    func goBack() {
        viewModel?.goBack()
    }

    func retrySearch() {
        viewModel?.retrySearch()
    }

    func getCurrentUser() -> String {
        guard let viewModel = viewModel else { return "" }
        return viewModel.getCurrentUser()
    }
}
