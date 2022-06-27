//
//  DZAlbum.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation

struct Album: Codable, Hashable {
    
    // MARK: - Properties
    
    var id: Int
    var title: String
    var upc: String?
    var link: String?
    var cover: String?
    var cover_small: String?
    var cover_medium: String?
    var cover_big: String?
    var cover_xl: String?
    var label: String?
    var nb_tracks: Int?
    var duration: Int?
    var fans: Int?
    var release_date: String?
    var record_type: String?
    var tracklist: String?
    var explicit_lyrics: Bool?
    var artist: Artist?
    var tracks: [Track]?
    
    // MARK: - Protocol Confirmance
    
    static func == (lhs: Album, rhs: Album) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
