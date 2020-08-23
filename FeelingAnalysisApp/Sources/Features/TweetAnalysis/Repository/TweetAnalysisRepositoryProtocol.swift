protocol TweetAnalysisRepositoryProtocol: AnyObject {
    func getAnalysis(from body: AnalysisObject,
                     completion: @escaping (Result<AnalysisResponse, NetworkError>) -> Void)
}
