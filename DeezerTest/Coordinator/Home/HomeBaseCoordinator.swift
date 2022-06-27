//
//  ChartBaseCoordinator.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 23/06/22.
//

import Foundation

protocol HomeBaseCoordinator: Coordinator {
    func moveToTrackListWith(artist: Artist)
    func moveToAlbumDetailWith(album: Album)
    func moveToPlaylistDetailWith(playlist: Playlist)
    func moveBackToHomePage()
}
