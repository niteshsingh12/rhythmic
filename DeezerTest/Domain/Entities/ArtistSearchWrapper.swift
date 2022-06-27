//
//  DZArtistSearchResponse.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 23/06/22.
//

import Foundation

struct ArtistSearchWrapper<T: Codable>: Codable {
    
    // MARK: - Properties
    
    var data: [T]
    var total: Int
    var next: String?
}
