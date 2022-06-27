//
//  MockTracksRepository.swift
//  DeezerTestTests
//
//  Created by Nitesh Singh on 27/06/22.
//

import XCTest
import Combine
@testable import DeezerTest

final class MockTracksRepository: TracksRepository {
    
    var networkService: NetworkService! = nil
    func fetchTracks(endpoint: DeezerEndpoint) -> AnyPublisher<ArtistSearchWrapper<Track>, NetworkError> {
        networkService.fetch(endpoint: endpoint)
    }
}
