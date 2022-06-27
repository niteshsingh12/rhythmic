//
//  DeezerEndpoint.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation
import CryptoKit

enum DeezerEndpoint: Endpoint {
    
    // MARK: - Endpoints
    
    case chart
    case search(request: ArtistSearch)
    case track(request: TracksRequest)
    case album(request: TracksRequest)
    case playlist(request: TracksRequest)
    
    // MARK: - URL Properties
    
    var scheme: String {
        switch self {
        default: return "https"
        }
    }
    
    var baseURL: String {
        switch self {
        default: return "api.deezer.com"
        }
    }
    
    var path: String {
        switch self {
        case .chart: return "/chart"
        case .search: return "/search/artist"
        case .track(let request): return "/artist/\(request.id)/top"
        case .album(let request): return "/album/\(request.id)/tracks"
        case .playlist(let request): return "/playlist/\(request.id)/tracks"
        }
    }
    
    var method: RequestMethod {
        switch self {
        default: return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        
        switch self {
            
        case .chart: return nil
            
        case .search(let request):
            let queryItems = [URLQueryItem(name: "q", value: request.query)]
            return queryItems
            
        case .track(let request):
            return fetchQueryItemsForTrackSearch(request: request)
            
        case .album(let request):
            return fetchQueryItemsForTrackSearch(request: request)
            
        case .playlist(let request):
            return fetchQueryItemsForTrackSearch(request: request)
        }
    }
}

// MARK: - Extension DeezerEndpoint

extension DeezerEndpoint {
    
    func fetchQueryItemsForTrackSearch(request: TracksRequest) -> [URLQueryItem] {
        let queryItems = [URLQueryItem(name: "limit", value: String(request.limit)), URLQueryItem(name: "index", value: String(request.index))]
        return queryItems
    }
}
