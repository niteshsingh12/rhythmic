//
//  DefaultSearchArtistsRepository.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 23/06/22.
//

import Foundation
import Combine

final class DefaultSearchArtistsRepository: SearchArtistsRepository {
    
    // MARK: - Properties
    
    let apiService: NetworkService
    
    // MARK: - Initializer
    
    init(service: NetworkService = DefaultNetworkService()) {
        apiService = service
    }
    
    // MARK: - Methods
    
    func fetchArtists(endpoint: DeezerEndpoint) -> AnyPublisher<ArtistSearchWrapper<Artist>, NetworkError> {
        apiService.fetch(endpoint: endpoint)
    }
}
