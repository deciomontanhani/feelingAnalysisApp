protocol TweetsListViewControllerProtocol: AnyObject {
    func set(viewModel: TweetsListViewModelProtocol)
    func showLoading()
    func showError(message: String?)
    func reloadTable()
}
