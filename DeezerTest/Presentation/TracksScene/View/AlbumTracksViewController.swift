//
//  AlbumTracksViewController.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 26/06/22.
//

import Foundation
import UIKit

final class AlbumTracksViewController: ArtistTracksViewController {
    
    // MARK: - Properties
    
    var album: Album
    
    // MARK: - Initializer
    
    init(album: Album, contentView: TracksDetailView, viewModel: TrackViewModel, imageRepository: ImageRepository) {
        self.album = album
        super.init(artist: album.artist, contentView: contentView, viewModel: viewModel, imageRepository: imageRepository)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden Methods
    
    override func fetchTrackListDetails() {
        
        let trackFetchRequest = TracksRequest(parentType: .album, id: album.id)
        tracksRequest = trackFetchRequest
        trackViewModel.fetchTracks(request: trackFetchRequest)
        updateContentViewData()
    }
    
    override func updateContentViewData() {
        contentView.titleVLabel.text = album.title
        
        if let artist = album.artist {
            contentView.subtitleLabel.text = artist.name
        }
        if let imageURL = album.cover_big {
            fetchImageWith(url: imageURL)
        }
    }
    
    override func loadMoreTracks() {
        isLoadingList = true
        
        let tracksFetchRequest = TracksRequest(parentType: .album, id: album.id, index: tracks.count)
        tracksRequest = tracksFetchRequest
        trackViewModel.fetchTracks(request: tracksFetchRequest)
    }
}
