//
//  SearchRepositorySearchCase.swift
//  DeezerTestTests
//
//  Created by Nitesh Singh on 27/06/22.
//

import XCTest
import Foundation
import Combine
@testable import DeezerTest

class SearchRepositoryTestCase: XCTestCase {

    private var mockSearchRepository: MockSearchRepository!
    private var searchViewModel: ArtistSearchViewModel!
    private var cancellables: Set<AnyCancellable>!
        
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockSearchRepository = MockSearchRepository()
        searchViewModel = ArtistSearchViewModel(service: mockSearchRepository)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        mockSearchRepository = nil
        searchViewModel = nil
        cancellables = nil
        try super.tearDownWithError()
    }
    
    func testSearchPredefinedText_testSearchModel_shouldReturnValidData() {
        let expectation = XCTestExpectation(description: "Search Mock Waiting For Success")

        let networkService = DefaultNetworkService(MockURLSession(data: FakeStub.generateFakeDataFromJSONWith(fileName: "SearchMock"),response: FakeStub.responsePass,error: nil))
        
        mockSearchRepository.networkService = networkService
        
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in }
        
        let valueHandler: (ArtistSearchWrapper<Artist>) -> Void = { (artists) in
            XCTAssertTrue(artists.data.count > 0)
            expectation.fulfill()
        }
        
        searchViewModel.service.fetchArtists(endpoint: .search(request: ArtistSearch(query: "Eminem")))
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
      }

    
    func testSearchArtists_shouldFailWhileDecoding()  {
        let expectation = XCTestExpectation(description: "Charts Mock Waiting For Decoding Error")

        let networkService = DefaultNetworkService(MockURLSession(data: FakeStub.generateFakeDataFromJSONWith(fileName: "IncorrectResponseMock"),response: FakeStub.responsePass,error: nil))
        
        mockSearchRepository.networkService = networkService
        
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in
            
            switch completion {
            case .failure(let error):
                XCTAssertEqual(error, .decodingError)
                expectation.fulfill()
            default: ()
            }
        }
        
        let valueHandler: (ArtistSearchWrapper<Artist>) -> Void = { (chart) in
            expectation.fulfill()
        }
        
        searchViewModel.service.fetchArtists(endpoint: .search(request: ArtistSearch(query: "Eminem")))
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
}
