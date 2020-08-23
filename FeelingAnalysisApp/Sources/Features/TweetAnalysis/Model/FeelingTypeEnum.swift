//
//  FeelingTypeEnum.swift
//  FeelingAnalysisApp
//
//  Created by Decio Montanhani on 22/08/20.
//  Copyright © 2020 Decio Montanhani. All rights reserved.
//

import Foundation

enum FeelingType {
    case happy
    case neutral
    case sad
}

extension FeelingType {
    static func getFeeling(score: Double) -> FeelingType {
        switch score {
        case -0.25...0.25:
            return .neutral
        case 0.26...1:
            return .happy
        case -1...(-0.26):
            return .sad
        default:
            return .neutral
        }
    }

    func getDescription() -> String {
        switch self {
        case .happy:
            return "Feliz 🙂"
        case .neutral:
            return "Neutro 😐"
        case .sad:
            return "Triste 🙁"
        }
    }
}
