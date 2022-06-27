//
//  DZPlaylist.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation

struct Playlist: Codable, Hashable {
    
    // MARK: - Properties
    
    var id: Int
    var title: String
    var description: String?
    var duration: Int?
    var nb_tracks: Int?
    var fans: Int?
    var link: String?
    var picture: String?
    var picture_small: String?
    var picture_medium: String?
    var picture_big: String?
    var picture_xl: String?
    var position: Int?
    var tracks: [Track]?
    var user: PlaylistCreator?
    
    // MARK: - Protocol Confirmance
    
    static func == (lhs: Playlist, rhs: Playlist) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct PlaylistCreator: Codable {
    let id: Int
    let name: String
}
