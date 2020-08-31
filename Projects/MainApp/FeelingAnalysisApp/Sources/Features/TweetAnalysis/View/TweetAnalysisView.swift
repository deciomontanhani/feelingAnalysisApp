import UIKit

final class TweetAnalysisView: UIView {

    weak var delegate: TweetAnalysisViewDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Esse tweet é:"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let feelingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var loadingErrorView: LoadingErrorView = {
        let view = LoadingErrorView()
        view.set(state: .loading)
        view.delegate = self
        return view
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        buildViewCode()
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

}

extension TweetAnalysisView: ViewCode {
    func buildHierarchy() {
        addSubview(titleLabel)
        addSubview(feelingLabel)
        addSubview(loadingErrorView)
    }

    func buildConstraints() {
        titleLabel.center(in: self, offset: CGPoint(x: 0, y: -20))
        titleLabel.horizontal(of: self, offset: 24)

        feelingLabel.topToBottom(of: titleLabel, offset: 16)
        feelingLabel.horizontal(of: self, offset: 24)

        loadingErrorView.edges(to: self)
    }

    func additionalSetup() {
        backgroundColor = .white
    }
}

extension TweetAnalysisView: TweetAnalysisViewProtocol {
    func show(result: String) {
        loadingErrorView.set(state: .hidden)
        feelingLabel.text = result
    }
    
    func showLoading() {
        loadingErrorView.set(state: .loading)
    }
    
    func showError(message: String) {
        loadingErrorView.set(text: message)
        loadingErrorView.set(state: .error)
    }
}

extension TweetAnalysisView: LoadingErrorViewProtocol {
    func retry() {
        delegate?.retry()
    }
}
