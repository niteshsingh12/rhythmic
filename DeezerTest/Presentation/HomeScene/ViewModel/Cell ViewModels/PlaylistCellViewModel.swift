//
//  PlaylistCelViewModel.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 22/06/22.
//

import Foundation
import Combine

final class PlaylistCellViewModel {
    
    // MARK: - Published Variables
    
    private(set) var playlistPublisher = PassthroughSubject<Playlist, Never>()
    
    // MARK: - Local Variables
    
    private let playlist: Playlist
    
    // MARK: - Initializer
    
    init(playlist: Playlist) {
        self.playlist = playlist
    }
    
    // MARK: - Helper Methods
    
    ///Convenience methods to publish comic values to its subscribers
    func publish() {
        playlistPublisher.send(playlist)
    }
}
