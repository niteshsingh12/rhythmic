//
//  TracksRepository.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 26/06/22.
//

import Combine

protocol TracksRepository {
    func fetchTracks(endpoint: DeezerEndpoint) -> AnyPublisher<ArtistSearchWrapper<Track>, NetworkError>
}
