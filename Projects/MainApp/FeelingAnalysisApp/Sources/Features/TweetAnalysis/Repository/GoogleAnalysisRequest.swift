//
//  TweetAnalysisRequest.swift
//  FeelingAnalysisApp
//
//  Created by Decio Montanhani on 22/08/20.
//  Copyright © 2020 Decio Montanhani. All rights reserved.
//

import Foundation
import Alamofake

struct GoogleAnalysisRequest: NetworkSession {
    let tweet: AnalysisObject

    init(tweet: AnalysisObject) {
        self.tweet = tweet
    }

    var baseUrl: String {
        return "language.googleapis.com"
    }

    var method: NetworkMethod {
        return .post
    }

    var path: String {
        return "v1/documents:analyzeSentiment"
    }

    var queryItems: [URLQueryItem] {
        return [URLQueryItem(name: "key",
                             value: ApiKeys.googleKey.rawValue)]
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

    var body: [String : Any]? {
        return tweet.dictionary
    }
}
