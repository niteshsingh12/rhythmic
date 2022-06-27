//
//  MockChartsRepository.swift
//  DeezerTestTests
//
//  Created by Nitesh Singh on 27/06/22.
//

import XCTest
import Combine
@testable import DeezerTest

final class MockChartsRepository: ChartsRepository {
        
    var networkService: NetworkService! = nil
    
    func fetchCharts(endpoint: DeezerEndpoint) -> AnyPublisher<Chart, NetworkError> {
        networkService.fetch(endpoint: endpoint)
    }
}
