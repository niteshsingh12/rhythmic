//
//  SearchArtistsRepository.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 26/06/22.
//

import Combine

protocol SearchArtistsRepository {
    func fetchArtists(endpoint: DeezerEndpoint) -> AnyPublisher<ArtistSearchWrapper<Artist>, NetworkError>
}
