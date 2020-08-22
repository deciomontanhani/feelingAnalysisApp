//
//  TwitterResponse.swift
//  FeelingAnalysisApp
//
//  Created by Decio Montanhani on 21/08/20.
//  Copyright © 2020 Decio Montanhani. All rights reserved.
//

import Foundation

struct TwitterResponse: Codable {
    let data: [Tweet]

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([Tweet].self, forKey: .data) ?? []
    }

}

struct Tweet: Codable {
    let id: String
    let text: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case text = "text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        text = try values.decodeIfPresent(String.self, forKey: .text) ?? ""
    }

}
