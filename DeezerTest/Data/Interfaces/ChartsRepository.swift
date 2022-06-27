//
//  ChartsRepository.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 26/06/22.
//

import Combine

protocol ChartsRepository {
    func fetchCharts(endpoint: DeezerEndpoint) -> AnyPublisher<Chart, NetworkError>
}
