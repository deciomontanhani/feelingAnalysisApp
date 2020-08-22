import UIKit

protocol TweetsListViewProtocol: UIView {
    func showLoading()
    func stopLoading()
    func showError(message: String?)
    func reloadTable()
}

protocol TweetsListViewDelegate: AnyObject {
    func goBack()
    func searchProfile(_ user: String)
    func getTweetsCount() -> Int
    func getTweetModel(at index: Int) -> Tweet?
    func didTapTweet(at index: Int)
    func retrySearch()
    func getCurrentUser() -> String
}
