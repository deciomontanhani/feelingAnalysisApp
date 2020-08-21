import UIKit

protocol TweetsListViewProtocol: UIView {}

protocol TweetsListViewDelegate: AnyObject {
    func goBack()
    func searchProfile(_ user: String)
}
