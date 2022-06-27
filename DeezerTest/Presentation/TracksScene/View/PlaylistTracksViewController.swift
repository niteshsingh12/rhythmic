//
//  PlaylistTracksViewController.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 26/06/22.
//

import Foundation

final class PlaylistTracksViewController: ArtistTracksViewController {
    
    // MARK: - Properties
    
    var playlist: Playlist
    
    // MARK: - Initializer
    
    init(playlist: Playlist, contentView: TracksDetailView, viewModel: TrackViewModel, imageRepository: ImageRepository) {
        self.playlist = playlist
        super.init(artist: nil, contentView: contentView, viewModel: viewModel, imageRepository: imageRepository)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden Methods
    
    override func fetchTrackListDetails() {
        
        let trackFetchRequest = TracksRequest(parentType: .playlist, id: playlist.id)
        tracksRequest = trackFetchRequest
        trackViewModel.fetchTracks(request: trackFetchRequest)
        updateContentViewData()
    }
    
    override func updateContentViewData() {
        contentView.titleVLabel.text = playlist.title
        
        if let user = playlist.user {
            contentView.subtitleLabel.text = "Curated by \(user.name)"
        }
        if let imageURL = playlist.picture_big {
            fetchImageWith(url: imageURL)
        }
    }
    
    override func loadMoreTracks() {
        isLoadingList = true
        let tracksFetchRequest = TracksRequest(parentType: .playlist, id: playlist.id, index: tracks.count)
        tracksRequest = tracksFetchRequest
        trackViewModel.fetchTracks(request: tracksFetchRequest)
    }
}
