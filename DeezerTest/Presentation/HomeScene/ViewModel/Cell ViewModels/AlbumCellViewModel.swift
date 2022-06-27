//
//  AlbumCellViewModel.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 22/06/22.
//

import Foundation
import Combine

final class AlbumCellViewModel {
    
    // MARK: - Published Variables
    
    private(set) var albumPublisher = PassthroughSubject<Album, Never>()
    
    // MARK: - Local Variables
    
    private let album: Album
    
    // MARK: - Initializer
    
    init(album: Album) {
        self.album = album
    }
    
    // MARK: - Helper Methods
    
    ///Convenience methods to publish comic values to its subscribers
    func publish() {
        albumPublisher.send(album)
    }
}
