//
//  Endpoint.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation

protocol Endpoint {
    
    // MARK: - Properties
    
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var method: RequestMethod { get }
}

// MARK: - Endpoint Extension

extension Endpoint {
    
    func createURLComponents() -> URLComponents {
        var components = URLComponents()
        
        components.path = path
        components.queryItems = queryItems
        components.host = baseURL
        components.scheme = scheme
        
        return components
    }
}
