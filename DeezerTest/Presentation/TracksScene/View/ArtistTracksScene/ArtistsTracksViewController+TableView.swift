//
//  ArtistsTracksViewController+CollectionView.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 27/06/22.
//

import Foundation
import UIKit

extension ArtistTracksViewController: UITableViewDataSource, UITableViewDelegate, NavigationDelegate {
    
    // MARK: - CollectionView Setup
    
    func setupTableView() {
        self.contentView.delegate = self
        contentView.tracksTableView.register(TrackTableViewCell.self, forCellReuseIdentifier: TrackTableViewCell.reuseIdentifer)
        contentView.tracksTableView.delegate = self
        contentView.tracksTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.reuseIdentifer, for: indexPath) as! TrackTableViewCell
        if !tracks.isEmpty {
            cell.configureDataWith(track: tracks[indexPath.row])
            cell.selectionStyle = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let track = tracks[indexPath.row]
        
        if !isMiniPlayerVisible {
            miniPlayer = self.addMiniPlayerToWindow()
            miniPlayer?.configure(track: track)
            addContentViewInsetIfMiniPlayerIsOn()
        } else {
            self.trackViewModel.trackCellDidTapped(for: tracks[indexPath.row])
        }
    }
    
    // MARK: - Navigation
    
    func didTapBackButton() {
        switch coordinator {
        case is HomeBaseCoordinator:
            (coordinator as! HomeBaseCoordinator).moveBackToHomePage()
        case is SearchBaseCoordinator:
            (coordinator as! SearchBaseCoordinator).moveBackToSearchPage()
        default: break
        }
    }
}
