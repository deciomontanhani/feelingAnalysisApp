//
//  TweetAnalysisViewModelTests.swift
//  FeelingAnalysisAppTests
//
//  Created by Decio Montanhani on 22/08/20.
//  Copyright © 2020 Decio Montanhani. All rights reserved.
//

import Foundation
import XCTest

@testable import FeelingAnalysisApp

final class TweetAnalysisViewModelTests: XCTestCase {

    private var viewModel: TweetAnalysisViewModel!

    private var mockRepository: RepositoryMock!
    private var mockController: ControllerMock!
    private var mockCoordinator: CoordinatorMock!

    private let sadResponse: AnalysisResponse = JsonUtil<AnalysisResponse>().decode(from: "SadFeeling")!
    private let neutralResponse: AnalysisResponse = JsonUtil<AnalysisResponse>().decode(from: "NeutralFeeling")!
    private let happyResponse: AnalysisResponse = JsonUtil<AnalysisResponse>().decode(from: "HappyFeeling")!

    override func setUp() {
        super.setUp()
        mockRepository = RepositoryMock()
        mockController = ControllerMock()
        mockCoordinator = CoordinatorMock()
    }

    private func setupViewModel(with tweet: String) {
        viewModel = TweetAnalysisViewModel(tweet: Tweet(id: "", text: tweet))
        viewModel.set(coordinator: mockCoordinator)
        viewModel.set(repository: mockRepository)
        viewModel.set(controller: mockController)
    }

    func testApiError() {
        given("I'm at TweetAnalysisViewModel") {
            self.setupViewModel(with: "Eu estou muito Feliz")
        }

        when("view didLoad") {
            self.mockRepository.stubbedGetAnalysisCompletionResult = ((.failure(.default)),())
            self.viewModel.didLoad()
        }

        then("should call error") {
            XCTAssertTrue(self.mockController.invokedShowError, "should show error in view")
            XCTAssertEqual(self.mockController.invokedShowErrorParameters?.message,
                           NetworkError.default.localizedDescription)
        }
    }

    func testApiHappyFeeling() {
        given("I'm at TweetAnalysisViewModel") {
            self.setupViewModel(with: "Eu estou muito feliz")
        }

        when("view didload") {
            self.mockRepository.stubbedGetAnalysisCompletionResult = ((.success(self.happyResponse)),())
            self.viewModel.didLoad()
        }

        then("it call view with happy message") {
            XCTAssertFalse(self.mockController.invokedShowError, "should not show error message")
            XCTAssertTrue(self.mockController.invokedShow)
            XCTAssertEqual(self.mockController.invokedShowParameters?.result, FeelingType.happy.getDescription())
            XCTAssertEqual(self.mockController.invokedShowParameters?.result, "Feliz 🙂")
        }
    }

    func testApiSadFeeling() {
        given("I'm at TweetAnalysisViewModel") {
            self.setupViewModel(with: "Eu estou muito triste")
        }

        when("view didload") {
            self.mockRepository.stubbedGetAnalysisCompletionResult = ((.success(self.sadResponse)),())
            self.viewModel.didLoad()
        }

        then("it call view with happy message") {
            XCTAssertFalse(self.mockController.invokedShowError, "should not show error message")
            XCTAssertTrue(self.mockController.invokedShow)
            XCTAssertEqual(self.mockController.invokedShowParameters?.result, FeelingType.sad.getDescription())
            XCTAssertEqual(self.mockController.invokedShowParameters?.result, "Triste 🙁")
        }
    }

    func testApiNeutralFeeling() {
        given("I'm at TweetAnalysisViewModel") {
            self.setupViewModel(with: "Eu estou andando pela rua")
        }

        when("view didload") {
            self.mockRepository.stubbedGetAnalysisCompletionResult = ((.success(self.neutralResponse)),())
            self.viewModel.didLoad()
        }

        then("it call view with happy message") {
            XCTAssertFalse(self.mockController.invokedShowError, "should not show error message")
            XCTAssertTrue(self.mockController.invokedShow)
            XCTAssertEqual(self.mockController.invokedShowParameters?.result, FeelingType.neutral.getDescription())
            XCTAssertEqual(self.mockController.invokedShowParameters?.result, "Neutro 😐")
        }
    }

    func testRetrySuccess() {
        given("I'm at TweetAnalysisViewModel") {
            self.setupViewModel(with: "Eu estou muito feliz")
        }

        when("view didload") {
            self.mockRepository.stubbedGetAnalysisCompletionResult = ((.success(self.happyResponse)),())
            self.viewModel.retry()
        }

        then("it call view with happy message") {
            XCTAssertFalse(self.mockController.invokedShowError, "should not show error message")
            XCTAssertTrue(self.mockController.invokedShow)
            XCTAssertEqual(self.mockController.invokedShowParameters?.result, FeelingType.happy.getDescription())
            XCTAssertEqual(self.mockController.invokedShowParameters?.result, "Feliz 🙂")
        }
    }
}

fileprivate final class CoordinatorMock: TweetAnalysisCoordinatorProtocol {}

fileprivate final class RepositoryMock: TweetAnalysisRepositoryProtocol {
    var invokedGetAnalysis = false
    var invokedGetAnalysisCount = 0
    var invokedGetAnalysisParameters: (body: AnalysisObject, Void)?
    var invokedGetAnalysisParametersList = [(body: AnalysisObject, Void)]()
    var stubbedGetAnalysisCompletionResult: (Result<AnalysisResponse, NetworkError>, Void)?
    func getAnalysis(from body: AnalysisObject,
    completion: @escaping (Result<AnalysisResponse, NetworkError>) -> Void) {
        invokedGetAnalysis = true
        invokedGetAnalysisCount += 1
        invokedGetAnalysisParameters = (body, ())
        invokedGetAnalysisParametersList.append((body, ()))
        if let result = stubbedGetAnalysisCompletionResult {
            completion(result.0)
        }
    }
}

fileprivate final class ControllerMock: TweetAnalysisViewControllerProtocol {
    var invokedSet = false
    var invokedSetCount = 0
    var invokedSetParameters: (viewModel: TweetAnalysisViewModelProtocol, Void)?
    var invokedSetParametersList = [(viewModel: TweetAnalysisViewModelProtocol, Void)]()
    func set(viewModel: TweetAnalysisViewModelProtocol) {
        invokedSet = true
        invokedSetCount += 1
        invokedSetParameters = (viewModel, ())
        invokedSetParametersList.append((viewModel, ()))
    }
    var invokedShowError = false
    var invokedShowErrorCount = 0
    var invokedShowErrorParameters: (message: String, Void)?
    var invokedShowErrorParametersList = [(message: String, Void)]()
    func showError(message: String) {
        invokedShowError = true
        invokedShowErrorCount += 1
        invokedShowErrorParameters = (message, ())
        invokedShowErrorParametersList.append((message, ()))
    }
    var invokedShow = false
    var invokedShowCount = 0
    var invokedShowParameters: (result: String, Void)?
    var invokedShowParametersList = [(result: String, Void)]()
    func show(result: String) {
        invokedShow = true
        invokedShowCount += 1
        invokedShowParameters = (result, ())
        invokedShowParametersList.append((result, ()))
    }
}
