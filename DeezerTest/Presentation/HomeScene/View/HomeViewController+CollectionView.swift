//
//  HomeViewController+CollectionView.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation
import UIKit

extension HomeViewController {
    
    // MARK: - CollectionView Setup
    
    func setupCollectionView() {
        
        contentView.listCollectionView.register(ArtistCell.self, forCellWithReuseIdentifier: ArtistCell.reuseIdentifer)
        contentView.listCollectionView.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.reuseIdentifer)
        contentView.listCollectionView.register(PlaylistCell.self, forCellWithReuseIdentifier: PlaylistCell.reuseIdentifer)
        contentView.listCollectionView.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.reuseIdentifer)
        contentView.listCollectionView.register(PodcastCell.self, forCellWithReuseIdentifier: PodcastCell.reuseIdentifer)
        
        contentView.listCollectionView.delegate = self
        contentView.listCollectionView.register(HeaderView.self,
                                                forSupplementaryViewOfKind: HeaderView.sectionHeaderElementKind,
            withReuseIdentifier: HeaderView.reuseIdentifier)
    }
    
    func setupDatasource() {
        
        datasource = Datasource(collectionView: contentView.listCollectionView, cellProvider: {
            (collectionView, indexPath, item) in
                        
            switch item {
               
            case let track as Track:
                
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TrackCell.reuseIdentifer,
                    for: indexPath) as? TrackCell else { fatalError("Could not create new cell") }
                
                cell.injectDependencies(imageRepository: self.imageRepository, viewModel: TrackCellViewModel(track: track))
                cell.viewModel.publish()
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                
                return cell
                
            case let artist as Artist:
                
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ArtistCell.reuseIdentifer,
                    for: indexPath) as? ArtistCell else { fatalError("Could not create new cell") }
                
                cell.injectDependencies(imageRepository: self.imageRepository, viewModel: ArtistCellViewModel(artist: artist))
                cell.viewModel.publish()
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                
                return cell
                
            case let album as Album:
                
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: AlbumCell.reuseIdentifer,
                    for: indexPath) as? AlbumCell else { fatalError("Could not create new cell") }
                
                cell.injectDependencies(imageRepository: self.imageRepository, viewModel: AlbumCellViewModel(album: album))
                cell.viewModel.publish()
                
                return cell
                
            case let playlist as Playlist:
                
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PlaylistCell.reuseIdentifer,
                    for: indexPath) as? PlaylistCell else { fatalError("Could not create new cell") }
                
                cell.injectDependencies(imageRepository: self.imageRepository, viewModel: PlaylistCellViewModel(playlist: playlist))
                cell.viewModel.publish()
                
                return cell
                
            case let podcast as Podcast:
                
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PodcastCell.reuseIdentifer,
                    for: indexPath) as? PodcastCell else { fatalError("Could not create new cell") }
                
                cell.injectDependencies(imageRepository: self.imageRepository, viewModel: PodcastCellViewModel(podcast: podcast))
                cell.viewModel.publish()
                
                return cell
                
            default:
                return UICollectionViewCell()
            }
        })
        configureSupplementaryViews()
    }
    
    private func configureSupplementaryViews() {
        
        datasource.supplementaryViewProvider = { (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderView.reuseIdentifier,
                for: indexPath) as? HeaderView else { fatalError("Cannot create header view") }
            
            let currentSnapShot = self.datasource.snapshot()
            let chartSection = currentSnapShot.sectionIdentifiers[indexPath.section]
            supplementaryView.headerLabel.text = chartSection.localized
            
            return supplementaryView
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    // MARK: - CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        guard let user = datasource.itemIdentifier(for: indexPath) else { return }
        
        switch user {
            
        case let track as Track:
            
            guard miniPlayer != nil else {
                showMiniMusicPlayerFor(track: track)
                miniPlayer?.configure(track: track)
                return
            }
            
            miniPlayer?.configure(track: track)
            
        case let album as Album:
            coordinator?.moveToAlbumDetailWith(album: album)
        case let artist as Artist:
            coordinator?.moveToTrackListWith(artist: artist)
        case let playlist as Playlist:
            coordinator?.moveToPlaylistDetailWith(playlist: playlist)
        default: ()
        }
    }
}
