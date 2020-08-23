protocol TweetsListViewModelProtocol: AnyObject {
    func searchProfile(_ user: String)
    func getTweetsCount() -> Int
    func getTweetModel(at index: Int) -> Tweet?
    func didTapTweet(at index: Int)
    func retrySearch()
    func getCurrentUser() -> String
}
