//
//  TrackCellViewModel.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 21/06/22.
//

import Foundation
import Combine

final class TrackCellViewModel {
    
    // MARK: - Published Variables
    
    private(set) var trackPublisher = PassthroughSubject<Track, Never>()
    
    // MARK: - Local Variables
    
    private let track: Track
    
    // MARK: - Initializer
    
    init(track: Track) {
        self.track = track
    }
    
    // MARK: - Helper Methods
    
    ///Convenience methods to publish comic values to its subscribers
    func publish() {
        trackPublisher.send(track)
    }
    
    func didTapPlayButton(for track: Track, isPlayingTrack: Bool) {
        
        if isPlayingTrack {
            AudioPlayerService.shared.pause()
        }
        else {
            AudioPlayerService.shared.play(withStringUrl: track.preview!)
        }
    }
}
