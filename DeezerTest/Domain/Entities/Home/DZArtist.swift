//
//  DZArtist.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation

struct Artist: Codable, Hashable {
    
    // MARK: - Properties
    
    var id: Int
    var name: String
    var link: String?
    var picture: String?
    var picture_small: String?
    var picture_big: String?
    var picture_medium: String?
    var picture_xl: String?
    var nb_album: Int?
    var nb_fan: Int?
    var tracklist: String?
    
    // MARK: - Protocol Confirmance
    
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
