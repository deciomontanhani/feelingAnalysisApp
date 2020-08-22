protocol TweetsListRepositoryProtocol: AnyObject {
    func getTweets(from user: String, nextPageToken: String?, maxResults: Int, completion: @escaping (Result<TwitterResponse, NetworkError>) -> Void)
}
