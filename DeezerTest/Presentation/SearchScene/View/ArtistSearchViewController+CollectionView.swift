//
//  ArtistSearchViewController+CollectionView.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 24/06/22.
//

import Foundation
import UIKit

extension ArtistSearchViewController {
    
    // MARK: - CollectionView Setup
    
    func setupCollectionView() {
        
        contentView.listCollectionView.register(ArtistCell.self, forCellWithReuseIdentifier: ArtistCell.reuseIdentifer)
        contentView.listCollectionView.register(PlaylistCell.self, forCellWithReuseIdentifier: PlaylistCell.reuseIdentifer)
        contentView.listCollectionView.register(PodcastCell.self, forCellWithReuseIdentifier: PodcastCell.reuseIdentifer)
        
        contentView.listCollectionView.delegate = self
        contentView.listCollectionView.register(HeaderView.self,
                                                forSupplementaryViewOfKind: HeaderView.sectionHeaderElementKind,
                                                withReuseIdentifier: HeaderView.reuseIdentifier)
    }
    
    func setupDatasource() {
        
        let registeredCells = artistCellRegistration()
        
        datasource = Datasource(collectionView: contentView.listCollectionView, cellProvider: {
            (collectionView, indexPath, item) in
            
            guard let sectionItem = self.currentSnapshot?.sectionIdentifier(containingItem: item) else { return UICollectionViewCell() }
            
            switch sectionItem {
                
            case .popular:
                
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ArtistCell.reuseIdentifer,
                    for: indexPath) as? ArtistCell else { fatalError("Could not create new cell") }
                
                cell.injectDependencies(imageRepository: self.imageRepository, viewModel: ArtistCellViewModel(artist: item as! Artist))
                cell.viewModel.publish()
                
                return cell
                
            case .others:
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: registeredCells, for: indexPath, item: item as? Artist)
                return cell
            }
        })
        configureSupplementaryViews()
    }
    
    private func configureSupplementaryViews() {
        
        datasource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            
            let currentSnapShot = self.datasource.snapshot()
            let chartSection = currentSnapShot.sectionIdentifiers[indexPath.section]
            
            switch chartSection {
            case .popular, .others :
                
                guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: HeaderView.reuseIdentifier,
                    for: indexPath) as? HeaderView else { fatalError("Cannot create header view") }
                
                let currentSnapShot = self.datasource.snapshot()
                let chartSection = currentSnapShot.sectionIdentifiers[indexPath.section]
                supplementaryView.headerLabel.text = chartSection.localized
                
                return supplementaryView
            }
        }
    }
    
    private func artistCellRegistration() -> UICollectionView.CellRegistration<TaskManagerListCell, Artist> {
        
        return UICollectionView.CellRegistration<TaskManagerListCell, Artist> { (cell, indexPath, item) in
            cell.injectDependencies(imageRepository: self.imageRepository, artist: item)
        }
    }
}

extension ArtistSearchViewController: UICollectionViewDelegate {
    
    // MARK: - CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        guard let artist = datasource.itemIdentifier(for: indexPath) as? Artist else { return }
        coordinator?.moveToTrackListWith(artist: artist)
    }
}
