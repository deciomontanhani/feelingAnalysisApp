//
//  AnalysisObject.swift
//  FeelingAnalysisApp
//
//  Created by Decio Montanhani on 22/08/20.
//  Copyright © 2020 Decio Montanhani. All rights reserved.
//

import Foundation

struct AnalysisObject: Codable {
    let encodingType: String
    let document: AnalysisDocument

    init(tweet: String) {
        encodingType = "UTF8"
        document = AnalysisDocument(type: .plainText, content: tweet)
    }
}

struct AnalysisDocument: Codable {
    let type: AnalysisType
    let content: String
}

enum AnalysisType: String, Codable {
    case plainText = "PLAIN_TEXT"
}
