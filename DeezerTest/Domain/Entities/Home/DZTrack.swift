//
//  DZTrack.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation

struct Track: Codable, Hashable {
    
    // MARK: - Properties
    
    var id: Int
    var readable: Bool?
    var title: String
    var title_short: String?
    var title_version: String?
    var link: String?
    var duration: Int?
    var track_position: Int?
    var position: Int?
    var disk_number: Int?
    var rank: Int?
    var release_date: String?
    var contributors: [Artist]?
    var explicit_lyrics: Bool?
    var preview: String?
    var bpm: Double?
    var album: Album?
    var artist: Artist
    
    // MARK: - Protocol Confirmance
    
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
