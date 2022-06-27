//
//  NetworkService.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation
import Combine

protocol NetworkService {
    func fetch<T: Codable>(endpoint: Endpoint) -> AnyPublisher<T, NetworkError>
}
