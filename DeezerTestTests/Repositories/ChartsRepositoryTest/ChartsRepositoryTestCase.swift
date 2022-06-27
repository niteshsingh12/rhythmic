//
//  ChartsRepositoryTestCase.swift
//  DeezerTestTests
//
//  Created by Nitesh Singh on 27/06/22.
//

import XCTest
import Foundation
import Combine
@testable import DeezerTest

class ChartsRepositoryTestCase: XCTestCase {

    private var mockChartsRepository: MockChartsRepository!
    private var chartsViewModel: HomeViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    private var service: NetworkService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockChartsRepository = MockChartsRepository()
        chartsViewModel = HomeViewModel(service: mockChartsRepository)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        mockChartsRepository = nil
        chartsViewModel = nil
        cancellables = nil
        try super.tearDownWithError()
    }
    
    func testFetchCharts_shouldReturnValidData() throws {
        let expectation = XCTestExpectation(description: "Charts Mock Waiting For Success")

        let networkService = DefaultNetworkService(MockURLSession(data: FakeStub.generateFakeDataFromJSONWith(fileName: "ChartsMock"),response: FakeStub.responsePass,error: nil))
        
        mockChartsRepository.networkService = networkService
        
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in
        }
        
        let valueHandler: (Chart) -> Void = { (chart) in
            XCTAssertEqual(chart.albums.data.count, 9)
            XCTAssertEqual(chart.tracks.data.count, 10)
            XCTAssertEqual(chart.artists.data.count, 10)
            XCTAssertEqual(chart.playlists.data.count, 10)
            XCTAssertEqual(chart.podcasts.data.count, 10)
            expectation.fulfill()
        }
        
        chartsViewModel.service.fetchCharts(endpoint: .chart)
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
      }

    func testFetchCharts_shouldFailIfServerError()  {
        let expectation = XCTestExpectation(description: "Charts Mock Waiting For Error")

        let networkService = DefaultNetworkService(MockURLSession(data: FakeStub.generateFakeDataFromJSONWith(fileName: "IncorrectResponseMock"),response: FakeStub.responseFail,error: nil))
        
        mockChartsRepository.networkService = networkService
        
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in
            
            switch completion {
            case .failure(let error):
                XCTAssertEqual(error, .serverError(500))
                expectation.fulfill()
            default: ()
            }
        }
        
        let valueHandler: (Chart) -> Void = { (chart) in
            expectation.fulfill()
        }
        
        chartsViewModel.service.fetchCharts(endpoint: .chart)
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchCharts_shouldFailWhileDecoding()  {
        let expectation = XCTestExpectation(description: "Charts Mock Waiting For Decoding Error")

        let networkService = DefaultNetworkService(MockURLSession(data: FakeStub.generateFakeDataFromJSONWith(fileName: "IncorrectResponseMock"),response: FakeStub.responsePass,error: nil))
        
        mockChartsRepository.networkService = networkService
        
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in
            
            switch completion {
            case .failure(let error):
                
                print(error)
                XCTAssertEqual(error, .decodingError)
                expectation.fulfill()
            default: ()
            }
        }
        
        let valueHandler: (Chart) -> Void = { (chart) in
            expectation.fulfill()
        }
        
        chartsViewModel.service.fetchCharts(endpoint: .chart)
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
}
