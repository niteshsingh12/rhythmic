//
//  DefaultChartRepository.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation
import Combine

final class DefaultChartRepository: ChartsRepository {
    
    // MARK: - Properties
    
    let apiService: NetworkService
    
    // MARK: - Initializer
    
    init(service: NetworkService = DefaultNetworkService()) {
        apiService = service
    }
    
    // MARK: - Methods
    
    func fetchCharts(endpoint: DeezerEndpoint) -> AnyPublisher<Chart, NetworkError> {
        apiService.fetch(endpoint: endpoint)
    }
}
