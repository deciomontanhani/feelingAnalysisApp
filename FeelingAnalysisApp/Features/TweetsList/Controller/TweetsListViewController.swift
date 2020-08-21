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
    func set(viewModel: TweetsListViewModelProtocol) {
        self.viewModel = viewModel
    }
}

extension TweetsListViewController: TweetsListViewDelegate {
    func searchProfile(_ user: String) {
        
    }

    func goBack() {
        viewModel?.goBack()
    }
}
