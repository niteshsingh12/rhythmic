//
//  DZPodcast.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation

struct Podcast: Codable, Hashable {
    
    // MARK: - Properties
    
    var id: Int
    var title: String
    var description: String?
    var available: Bool?
    var fans: Int?
    var link: String?
    var picture: String?
    var picture_small: String?
    var picture_medium: String?
    var picture_big: String?
    var picture_xl: String?
    var position: Int?
    
    // MARK: - Protocol Confirmance
    
    static func == (lhs: Podcast, rhs: Podcast) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
