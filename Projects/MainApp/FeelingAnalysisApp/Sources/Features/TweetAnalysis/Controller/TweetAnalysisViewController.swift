import UIKit

final class TweetAnalysisViewController: UIViewController {

    private var viewModel: TweetAnalysisViewModelProtocol?
    private lazy var customView: TweetAnalysisViewProtocol = {
        let view = TweetAnalysisView()
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.didLoad()
        title = "Analysis"
    }

    override func loadView() {
        view = customView
    }
}

extension TweetAnalysisViewController: TweetAnalysisViewControllerProtocol {
    func showError(message: String) {
        customView.showError(message: message)
    }

    func show(result: String) {
        customView.show(result: result)
    }

    func set(viewModel: TweetAnalysisViewModelProtocol) {
        self.viewModel = viewModel
    }
}

extension TweetAnalysisViewController: TweetAnalysisViewDelegate {
    func retry() {
        viewModel?.retry()
    }
}
