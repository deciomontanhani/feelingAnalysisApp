//
//  TweetAnalysisRepository.swift
//  FeelingAnalysisApp
//
//  Created by Decio Montanhani on 22/08/20.
//  Copyright © 2020 Decio Montanhani. All rights reserved.
//

final class TweetAnalysisRepository: TweetAnalysisRepositoryProtocol {
    func getAnalysis(from body: AnalysisObject, completion: @escaping (Result<AnalysisResponse, NetworkError>) -> Void) {
        GoogleAnalysisRequest(tweet: body).execute(completion: completion)
    }
}
