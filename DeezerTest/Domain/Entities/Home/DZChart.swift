//
//  DZChart.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation

struct Chart: Codable, Hashable {
    
    // MARK: - Properties
    
    var uuid = UUID()
    var tracks: Data<Track>
    var albums: Data<Album>
    var artists: Data<Artist>
    var playlists: Data<Playlist>
    var podcasts: Data<Podcast>
    
    // MARK: - Coding Keys
    
    private enum CodingKeys : String, CodingKey { case tracks, albums, artists, playlists, podcasts
    }
    
    // MARK: - Protocol Confirmance
    
    static func == (lhs: Chart, rhs: Chart) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

struct Data<T: Codable>: Codable {
    
    // MARK: - Properties
    
    var data: [T]
    var total: Int
}
