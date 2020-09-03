//
//  TweetsRequest.swift
//  FeelingAnalysisApp
//
//  Created by Decio Montanhani on 21/08/20.
//  Copyright © 2020 Decio Montanhani. All rights reserved.
//

import Foundation
import Alamofake

struct TweetsRequest: NetworkSession {

    let username: String
    let nextToken: String?
    let maxResults: Int

    init(username: String, nextToken: String?, maxResults: Int) {
        self.username = username
        self.nextToken = nextToken
        self.maxResults = maxResults
    }

    var baseUrl: String {
        return "api.twitter.com"
    }

    var method: NetworkMethod {
        return .get
    }

    var path: String {
        return "2/tweets/search/recent"
    }

    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem(name: "query", value: "from:\(username)"),
                     URLQueryItem(name: "max_results", value: "\(maxResults)")]
        if let token = nextToken {
            items.append(URLQueryItem(name: "next_token", value: token))
        }
        return items
    }

    var headers: [String : String]? {
        return ["Authorization": ApiKeys.twitterToken.rawValue,
                "Content-Type": "application/json"]
    }
}
