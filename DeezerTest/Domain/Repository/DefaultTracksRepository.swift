//
//  DefaultTracksRepository.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 24/06/22.
//

import Foundation
import Combine

final class DefaultTracksRepository: TracksRepository {
    
    // MARK: - Properties
    
    let apiService: NetworkService
    
    // MARK: - Initializer
    
    init(service: NetworkService = DefaultNetworkService()) {
        apiService = service
    }
    
    // MARK: - Methods
    
    func fetchTracks(endpoint: DeezerEndpoint) -> AnyPublisher<ArtistSearchWrapper<Track>, NetworkError> {
        apiService.fetch(endpoint: endpoint)
    }
}
