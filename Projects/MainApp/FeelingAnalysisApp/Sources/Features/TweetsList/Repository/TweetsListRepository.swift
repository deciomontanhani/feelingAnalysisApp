import Alamofake

final class TweetsListRepository: TweetsListRepositoryProtocol {
    func getTweets(from user: String,
                   nextPageToken: String?,
                   maxResults: Int,
                   completion: @escaping (Result<TwitterResponse, NetworkError>) -> Void) {
        TweetsRequest(username: user,
                      nextToken: nextPageToken,
                      maxResults: maxResults).execute(completion: completion)
    }
}
