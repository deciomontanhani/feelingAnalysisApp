//
//  XCTestCase+Extensions.swift
//  FeelingAnalysisAppTests
//
//  Created by Decio Montanhani on 22/08/20.
//  Copyright © 2020 Decio Montanhani. All rights reserved.
//

import XCTest

extension XCTestCase {

    typealias FeatureOperation = () -> Void

    func given(_ description: String, _ operation: @escaping FeatureOperation) {
        performOperation(operation, description: "Given \(description)")
    }

    func when(_ description: String, _ operation: @escaping FeatureOperation) {
        performOperation(operation, description: "When \(description)")
    }

    func and(_ description: String, _ operation: @escaping FeatureOperation) {
        performOperation(operation, description: "And \(description)")
    }

    func then(_ description: String, _ operation: @escaping FeatureOperation) {
        performOperation(operation, description: "Then \(description)")
    }

    private func performOperation(_ operation: FeatureOperation, description: String) {
        XCTContext.runActivity(named: description) { _ in operation() }
    }
}
