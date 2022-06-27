//
//  PodcastCellViewModel.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 22/06/22.
//

import Foundation
import Combine

final class PodcastCellViewModel {
    
    // MARK: - Published Variables
    
    private(set) var podcastPublisher = PassthroughSubject<Podcast, Never>()
    
    // MARK: - Local Variables
    
    private let podcast: Podcast
    
    // MARK: - Initializer
    
    init(podcast: Podcast) {
        self.podcast = podcast
    }
    
    // MARK: - Helper Methods
    
    ///Convenience methods to publish comic values to its subscribers
    func publish() {
        podcastPublisher.send(podcast)
    }
}
