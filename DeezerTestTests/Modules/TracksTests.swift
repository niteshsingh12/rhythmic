//
//  TracksTests.swift
//  DeezerTestTests
//
//  Created by Nitesh Singh on 27/06/22.
//

import XCTest
import Foundation
import Combine
@testable import DeezerTest

class TracksViewModelTestCase: XCTestCase {

    private var mockTracksRepository: MockTracksRepository!
    private var tracksViewModel: TrackViewModel!
    private var tracksScene: ArtistTracksViewController!
    private var cancellables: Set<AnyCancellable>!
    private var tracksView: TracksDetailView!
    
    private var service: NetworkService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockTracksRepository = MockTracksRepository()
        tracksViewModel = TrackViewModel(service: mockTracksRepository)
        tracksView = TracksDetailView()
        
        let artist = Artist(id: 1, name: "Eminem", nb_album: 10, nb_fan: 5000000)
        
        tracksScene = ArtistTracksViewController(artist: artist, contentView: tracksView, viewModel: tracksViewModel, imageRepository: DefaultImageRepository())
        
        let networkService = DefaultNetworkService(MockURLSession(data: FakeStub.generateFakeDataFromJSONWith(fileName: "TracksMock"),response: FakeStub.responsePass,error: nil))

        mockTracksRepository.networkService = networkService
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        mockTracksRepository = nil
        tracksViewModel = nil
        tracksScene = nil
        cancellables = nil
        tracksView = nil
        try super.tearDownWithError()
    }
    
    func testIfTrackDependeniesAssigned_forViewAndViewModels() {
        let expectation = XCTestExpectation(description: "Checking If Dependencies Are Loaded")
        XCTAssertTrue(tracksScene.view.isKind(of: TracksDetailView.self))
        XCTAssertNotNil(tracksScene.artist)
        expectation.fulfill()
    }
    
    func testIfTrackDataIsLoadedThroughTracksPublisher() {
        
        let expectation = XCTestExpectation(description: "Checking If Dependencies Are Loaded")
        
        tracksScene.trackViewModel.tracks
            .sink(receiveCompletion: {_ in
                
            }, receiveValue: { [weak self] tracks in
                self?.tracksScene.tracks.append(contentsOf: tracks.data)
                XCTAssertFalse(tracks.data.count == 0)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        tracksScene.trackViewModel.fetchTracks(request: TracksRequest(id: 27))
    }
    
    func testIfTracksReceived_andSectionsLoaded_afterNetworkAPICall() {
        let expectation = XCTestExpectation(description: "Checking If Sections Are Loaded With Data")

        tracksScene.trackViewModel.tracks
            .sink(receiveCompletion: {_ in
                
            }, receiveValue: { [weak self] tracks in
                self?.tracksScene.tracks.append(contentsOf: tracks.data)
                self?.tracksScene.contentView.tracksTableView.reloadData()
                XCTAssertEqual(self?.tracksScene.contentView.tracksTableView.numberOfSections, 1)
                XCTAssertEqual(self?.tracksScene.contentView.tracksTableView.numberOfRows(inSection: 0), self?.tracksScene.tracks.count)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        tracksScene.setupTableView()
        tracksScene.setupBindings()
        tracksScene.trackViewModel.fetchTracks(request: TracksRequest(id: 27))
    }
}
