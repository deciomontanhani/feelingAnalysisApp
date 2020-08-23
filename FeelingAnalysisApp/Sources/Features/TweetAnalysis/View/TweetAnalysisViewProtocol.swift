import UIKit

protocol TweetAnalysisViewProtocol: UIView {
    func show(result: String)
    func showLoading()
    func showError(message: String)
}

protocol TweetAnalysisViewDelegate: AnyObject {
    func retry()
}
