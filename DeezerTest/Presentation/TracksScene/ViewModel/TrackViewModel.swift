//
//  TrackViewModel.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 24/06/22.
//

import Foundation
import Combine

final class TrackViewModel {
    
    // MARK: - Properties
    
    var tracks = PassthroughSubject<ArtistSearchWrapper<Track>, Never>()
    @Published var state: ViewModelState = .loading
    var service: TracksRepository
    private var bindings = Set<AnyCancellable>()
        
    private var isTrackPlaying: Bool {
        return AudioPlayerService.shared.isPlaying
    }
    
    var currentTrack: Track? {
        didSet {
            if isTrackPlaying {
                pauseTrack()
            }
            playTrack()
        }
    }
    
    // MARK: - Initializer
    
    init(service: TracksRepository) {
        self.service = service
    }
    
    // MARK: - Methods
    
    func playTrack() {
        if let currentTrack = currentTrack, let preview = currentTrack.preview {
            AudioPlayerService.shared.play(withStringUrl: preview)
        }
    }
    
    func pauseTrack() {
        AudioPlayerService.shared.pause()
    }
    
    func trackCellDidTapped(for track: Track) {
        currentTrack = track
        NotificationCenter.default.post(name: .newTrackPlayed, object: nil, userInfo: ["track": track])
    }
    
    func fetchTracks(request: TracksRequest) {
        
        state = .loading
        
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { [weak self] completion in
            
            switch completion {
            case .failure(let error):
                self?.state = .error(error)
            default: ()
            }
        }
        
        let valueHandler: (ArtistSearchWrapper<Track>) -> Void = { [weak self] trackResponse in
            self?.tracks.send(trackResponse)
        }
        
        var endpoint: DeezerEndpoint = .track(request: request)
        
        switch request.parentType {
        case .album:
            endpoint = .album(request: request)
        case .playlist:
            endpoint = .playlist(request: request)
        default: ()
        }
        
        service.fetchTracks(endpoint: endpoint)
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &bindings)
    }
}
