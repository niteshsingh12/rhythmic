//
//  ArtistSearchRequest.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 23/06/22.
//

import Foundation

enum ArtistSearchOrder: String {
    case ranking
    case rating
}

struct ArtistSearch {
    
    // MARK: - Properties
    
    var query: String
    var orderBy: ArtistSearchOrder? = .ranking
    var limit: Int = 100
}
