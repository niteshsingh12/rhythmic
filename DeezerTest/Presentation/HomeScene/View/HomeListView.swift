//
//  HomeListView.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation
import UIKit

final class HomeListView: UIView {
    
    // MARK: - Properties
    
    lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayoutForHomeCollectionView())
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
        
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setup() {
        let subviews = [listCollectionView]
        
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            listCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            listCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            listCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            listCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

// MARK: - Extension HomeListView

extension HomeListView {
    
    private func createLayoutForHomeCollectionView() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            switch sectionNumber {
                
            case 0: return CollectionLayoutGenerator.generateTrackListSection()
            case 1: return CollectionLayoutGenerator.generateArtistSection()
            case 2: return CollectionLayoutGenerator.generateAlbumSection()
                
            default: return CollectionLayoutGenerator.generatePodcastSection()
            }
        }
    }
}
