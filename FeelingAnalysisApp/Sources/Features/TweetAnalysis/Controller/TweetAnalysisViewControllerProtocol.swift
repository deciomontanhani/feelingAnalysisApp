protocol TweetAnalysisViewControllerProtocol: AnyObject {
    func set(viewModel: TweetAnalysisViewModelProtocol)
    func showError(message: String)
    func show(result: String)
}
