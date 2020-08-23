//
//  AnalysisResponse.swift
//  FeelingAnalysisApp
//
//  Created by Decio Montanhani on 22/08/20.
//  Copyright © 2020 Decio Montanhani. All rights reserved.
//

import Foundation

struct AnalysisResponse: Codable {
    let documentSentiment: AnalysisDocumentSentiment?
}

struct AnalysisDocumentSentiment: Codable {
    let magnitude: Double
    let score: Double

    enum CodingKeys: String, CodingKey {
        case magnitude
        case score
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        magnitude = try values.decodeIfPresent(Double.self, forKey: .magnitude) ?? 0.0
        score = try values.decodeIfPresent(Double.self, forKey: .score) ?? 0.0
    }

}
