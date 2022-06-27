//
//  TrackRespositoryTestCase.swift
//  DeezerTestTests
//
//  Created by Nitesh Singh on 27/06/22.
//

import XCTest
import Foundation
import Combine
@testable import DeezerTest

class TracksRepositoryTestCase: XCTestCase {

    private var mockTracksRepository: MockTracksRepository!
    private var tracksViewModel: TrackViewModel!
    private var cancellables: Set<AnyCancellable>!
        
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockTracksRepository = MockTracksRepository()
        tracksViewModel = TrackViewModel(service: mockTracksRepository)
        
        let networkService = DefaultNetworkService(MockURLSession(data: FakeStub.generateFakeDataFromJSONWith(fileName: "TracksMock"),response: FakeStub.responsePass,error: nil))
        
        mockTracksRepository.networkService = networkService
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        mockTracksRepository = nil
        tracksViewModel = nil
        cancellables = nil
        try super.tearDownWithError()
    }
    
    func testTracksPredefinedText_testSearchModel_shouldReturnValidData() {
        let expectation = XCTestExpectation(description: "Artist Tracks Coverage")

        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in }
        
        let artistId = 27
        
        let valueHandler: (ArtistSearchWrapper<Track>) -> Void = { (tracks) in
            XCTAssertEqual(artistId, tracks.data.first!.artist.id)
            expectation.fulfill()
        }
        
        tracksViewModel.service.fetchTracks(endpoint: .track(request: TracksRequest(id: 27)))
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
      }

    
    func testSearchTracks_shouldFailWhileDecoding()  {
        let expectation = XCTestExpectation(description: "Tracks Error")

        let networkService = DefaultNetworkService(MockURLSession(data: FakeStub.generateFakeDataFromJSONWith(fileName: "IncorrectResponseMock"),response: FakeStub.responsePass,error: nil))

        mockTracksRepository.networkService = networkService
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in

            switch completion {
            case .failure(let error):
                XCTAssertEqual(error, .decodingError)
                expectation.fulfill()
            default: ()
            }
        }

        let valueHandler: (ArtistSearchWrapper<Track>) -> Void = { (chart) in
            expectation.fulfill()
        }

        tracksViewModel.service.fetchTracks(endpoint: .track(request: TracksRequest(id: 27)))
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
}
