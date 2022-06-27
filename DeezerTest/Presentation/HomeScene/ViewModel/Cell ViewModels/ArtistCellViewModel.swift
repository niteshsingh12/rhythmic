//
//  ArtistCellViewModel.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation
import Combine

final class ArtistCellViewModel {
    
    // MARK: - Published Variables
    
    private(set) var artistPublisher = PassthroughSubject<Artist, Never>()
    
    // MARK: - Local Variables
    
    private let artist: Artist
    
    // MARK: - Initializer
    
    init(artist: Artist) {
        self.artist = artist
    }
    
    // MARK: - Helper Methods
    
    ///Convenience methods to publish comic values to its subscribers
    func publish() {
        artistPublisher.send(artist)
    }
}
