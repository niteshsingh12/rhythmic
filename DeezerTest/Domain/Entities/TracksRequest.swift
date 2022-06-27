//
//  TrackFetchRequest.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 24/06/22.
//

import Foundation

enum TracksType {
    case artist
    case album
    case playlist
}

struct TracksRequest {
    
    // MARK: - Properties
    
    var parentType: TracksType = .artist
    var id: Int
    var limit: Int = 20
    var index: Int = 0
}
