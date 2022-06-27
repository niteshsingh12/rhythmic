//
//  DefaultNetworkService.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation
import Combine

final class DefaultNetworkService: NetworkService {
    
    // MARK: - Properties
    
    var session: URLSession
    
    // MARK: - Initializer
    
    init(_ session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    // MARK: - Methods
    
    func fetch<T: Codable>(endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        
        let url = endpoint.createURLComponents().url
        
        guard let url = url else {
            return Fail(error: NetworkError.badRequest)
                .eraseToAnyPublisher()
        }
        
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20.0)
        
        return session
            .dataTaskPublisher(for: urlRequest)
            .tryMap({ data, response in
                if let response = response as? HTTPURLResponse,
                   !(200...299).contains(response.statusCode) {
                    throw self.httpError(response.statusCode)
                }
                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                self.handleMapError(error)
            }
            .retry(1)
            .eraseToAnyPublisher()
    }
}

// MARK: - Extension DefaultNetworkService

extension DefaultNetworkService {
    
    private func httpError(_ statusCode: Int) -> NetworkError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .clientError(statusCode)
        case 500...599: return .serverError(statusCode)
        default: return .unknownError
        }
    }
    
    private func handleMapError(_ error: Error) -> NetworkError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as NetworkError:
            return error
        default:
            return .unknownError
        }
    }
}
