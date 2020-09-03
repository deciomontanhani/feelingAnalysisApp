//
//  TweetsListViewModelTests.swift
//  FeelingAnalysisAppTests
//
//  Created by Decio Montanhani on 23/08/20.
//  Copyright © 2020 Decio Montanhani. All rights reserved.
//

import Foundation
import XCTest
import Alamofake

@testable import FeelingAnalysisApp

final class TweetsListViewModelTests: XCTestCase {

    private var viewModel: TweetsListViewModel!

    private var mockRepository: RepositoryMock!
    private var mockController: ControllerMock!
    private var mockCoordinator: CoordinatorMock!

    private let tweetsWithoutPagination: TwitterResponse = JsonUtil<TwitterResponse>().decode(from: "TweetsListWithoutPagination")!

    private let tweetsWithPagination: TwitterResponse = JsonUtil<TwitterResponse>().decode(from: "TweetPagination")!

    private let moreTweets: TwitterResponse = JsonUtil<TwitterResponse>().decode(from: "NewTweetsPage")!

    private let noResult: TwitterResponse = JsonUtil<TwitterResponse>().decode(from: "NoTweetsResult")!

    override func setUp() {
        super.setUp()
        mockRepository = RepositoryMock()
        mockController = ControllerMock()
        mockCoordinator = CoordinatorMock()
    }

    private func setupViewModel() {
        viewModel = TweetsListViewModel()
        viewModel.set(coordinator: mockCoordinator)
        viewModel.set(repository: mockRepository)
        viewModel.set(controller: mockController)
    }

    func testApiErrorWhenSearchingUser() {
        given("I'm at TweetsListViewModel") {
            self.setupViewModel()
        }

        when("I search an user") {
            self.mockRepository.stubbedGetTweetsCompletionResult = ((.failure(.default)),())
            self.viewModel.searchProfile("user_error")
        }

        then("it should show error") {
            XCTAssertTrue(self.mockController.invokedShowError)
            XCTAssertEqual(self.mockController.invokedShowErrorParameters?.message,
                           NetworkError.default.localizedDescription)
        }
    }

    func testUserNotFound() {
        given("I'm at TweetsListViewModel") {
            self.setupViewModel()
        }

        when("I search an user") {
            self.mockRepository.stubbedGetTweetsCompletionResult = ((.success(self.noResult)),())
            self.viewModel.searchProfile("user_not_found")
        }

        then("it should show error") {
            XCTAssertTrue(self.mockController.invokedShowError)
        }
    }

    func testGettingTweetModel() {
        var tweet: Tweet?

        given("I got tweets list from an user") {
            self.setupViewModel()
            self.mockRepository
                .stubbedGetTweetsCompletionResult = ((.success(self.tweetsWithPagination)),())
            self.viewModel.searchProfile("deciomontanhani")
        }

        when("I try to get the second Tweet from the list") {
            tweet = self.viewModel.getTweetModel(at: 1)
        }
        then("should return the right tweet") {
            XCTAssertEqual(tweet?.text, "Hoje eu estou muito feliz")
        }
    }

    func testTapInTweet() {
        given("I got tweets list from an user") {
            self.setupViewModel()
            self.mockRepository
                .stubbedGetTweetsCompletionResult = ((.success(self.tweetsWithPagination)),())
            self.viewModel.searchProfile("deciomontanhani")
        }

        when("I tapped in first tweet") {
            self.viewModel.didTapTweet(at: 1)
        }

        then("should go to result screen") {
            XCTAssertTrue(self.mockCoordinator.invokedGoToAnalysis)
            XCTAssertEqual(self.mockCoordinator.invokedGoToAnalysisCount, 1)
            XCTAssertEqual(self.mockCoordinator.invokedGoToAnalysisParameters?.tweet.text,
                           "Hoje eu estou muito feliz")
        }
    }

    func testTryingToFetchAgainAfterError() {
        given("I got an error") {
            self.setupViewModel()
            self.mockRepository.stubbedGetTweetsCompletionResult = ((.success(self.noResult)),())
            self.viewModel.searchProfile("user_not_found")
        }

        when("I try again to fetch") {
            self.viewModel.retrySearch()
        }

        then("it should call api again") {
            XCTAssertEqual(self.mockRepository.invokedGetTweetsCount, 2)
            XCTAssertEqual(self.mockRepository.invokedGetTweetsParameters?.user, "user_not_found")
        }
    }

    func testPagination() {
        given("I got tweets list from an user with pagination") {
            self.setupViewModel()
            self.mockRepository
                .stubbedGetTweetsCompletionResult = ((.success(self.tweetsWithPagination)),())
            self.viewModel.searchProfile("deciomontanhani")
        }

        when("I try to fetch more pages") {
            self.viewModel.fetchMore()
        }

        then("it should call api again") {
            XCTAssertEqual(self.mockRepository.invokedGetTweetsCount, 2)
            XCTAssertNotNil(self.mockRepository.invokedGetTweetsParameters?.nextPageToken)

        }
    }

    func testSucessSearching() {
        given("I'm at TweetsListViewModel") {
            self.setupViewModel()
        }

        when("searching for an user") {
            self.mockRepository
                .stubbedGetTweetsCompletionResult = ((.success(self.tweetsWithoutPagination)),())
            self.viewModel.searchProfile("deciomontanhani")
        }

        then("should show the results in view") {
            XCTAssertTrue(self.mockRepository.invokedGetTweets)
            XCTAssertTrue(self.mockController.invokedReloadTable)
            XCTAssertGreaterThan(self.viewModel.getTweetsCount(), 1)
            XCTAssertEqual(self.viewModel.getCurrentUser(), "deciomontanhani")
        }
    }

    func testTryingToGetMoreTweetsWhenTheListEnded() {
        given("I got tweets list from an user without pagination") {
            self.setupViewModel()
            self.mockRepository
                .stubbedGetTweetsCompletionResult = ((.success(self.tweetsWithoutPagination)),())
            self.viewModel.searchProfile("deciomontanhani")
        }

        when("I try to fetch more pages") {
            self.viewModel.fetchMore()
        }

        then("it should not call api again") {
            XCTAssertEqual(self.mockRepository.invokedGetTweetsCount, 1)
        }
    }
}

fileprivate final class CoordinatorMock: TweetsListCoordinatorProtocol {
    var invokedGoToAnalysis = false
    var invokedGoToAnalysisCount = 0
    var invokedGoToAnalysisParameters: (tweet: Tweet, Void)?
    var invokedGoToAnalysisParametersList = [(tweet: Tweet, Void)]()
    func goToAnalysis(tweet: Tweet) {
        invokedGoToAnalysis = true
        invokedGoToAnalysisCount += 1
        invokedGoToAnalysisParameters = (tweet, ())
        invokedGoToAnalysisParametersList.append((tweet, ()))
    }
}

fileprivate final class RepositoryMock: TweetsListRepositoryProtocol {
    var invokedGetTweets = false
    var invokedGetTweetsCount = 0
    var invokedGetTweetsParameters: (user: String, nextPageToken: String?, maxResults: Int)?
    var invokedGetTweetsParametersList = [(user: String, nextPageToken: String?, maxResults: Int)]()
    var stubbedGetTweetsCompletionResult: (Result<TwitterResponse, NetworkError>, Void)?
    func getTweets(from user: String, nextPageToken: String?, maxResults: Int, completion: @escaping (Result<TwitterResponse, NetworkError>) -> Void) {
        invokedGetTweets = true
        invokedGetTweetsCount += 1
        invokedGetTweetsParameters = (user, nextPageToken, maxResults)
        invokedGetTweetsParametersList.append((user, nextPageToken, maxResults))
        if let result = stubbedGetTweetsCompletionResult {
            completion(result.0)
        }
    }
}

fileprivate final class ControllerMock: TweetsListViewControllerProtocol {
    var invokedSet = false
    var invokedSetCount = 0
    var invokedSetParameters: (viewModel: TweetsListViewModelProtocol, Void)?
    var invokedSetParametersList = [(viewModel: TweetsListViewModelProtocol, Void)]()
    func set(viewModel: TweetsListViewModelProtocol) {
        invokedSet = true
        invokedSetCount += 1
        invokedSetParameters = (viewModel, ())
        invokedSetParametersList.append((viewModel, ()))
    }
    var invokedShowLoading = false
    var invokedShowLoadingCount = 0
    func showLoading() {
        invokedShowLoading = true
        invokedShowLoadingCount += 1
    }
    var invokedShowError = false
    var invokedShowErrorCount = 0
    var invokedShowErrorParameters: (message: String?, Void)?
    var invokedShowErrorParametersList = [(message: String?, Void)]()
    func showError(message: String?) {
        invokedShowError = true
        invokedShowErrorCount += 1
        invokedShowErrorParameters = (message, ())
        invokedShowErrorParametersList.append((message, ()))
    }
    var invokedReloadTable = false
    var invokedReloadTableCount = 0
    func reloadTable() {
        invokedReloadTable = true
        invokedReloadTableCount += 1
    }
}
