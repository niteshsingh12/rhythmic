//
//  MockSearchRepository.swift
//  DeezerTestTests
//
//  Created by Nitesh Singh on 27/06/22.
//

import XCTest
import Combine
@testable import DeezerTest

final class MockSearchRepository: SearchArtistsRepository {
    
    var networkService: NetworkService! = nil
    
    func fetchArtists(endpoint: DeezerEndpoint) -> AnyPublisher<ArtistSearchWrapper<Artist>, NetworkError> {
        networkService.fetch(endpoint: endpoint)
    }
}
