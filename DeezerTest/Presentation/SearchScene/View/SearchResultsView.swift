//
//  SearchResultsView.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 23/06/22.
//

import Foundation
import UIKit

final class SearchResultsView: UIView {
    
    // MARK: - Properties
    
    lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayoutForSeachCollectionView())
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.font = .subHeadlineFont
        searchBar.autocorrectionType = .no
        searchBar.placeholder = "search_placeholder".localized
        searchBar.tintColor = .blue
        return searchBar
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
        
        let subviews = [listCollectionView, searchBar]
        
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        listCollectionView.layoutMargins = .zero
        
        NSLayoutConstraint.activate([
            listCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            listCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            listCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            listCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

// MARK: - Extension SearchResultsView

extension SearchResultsView {
    
    ///Create lcompositional layouts
    private func createLayoutForSeachCollectionView() -> UICollectionViewCompositionalLayout {

        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            switch sectionIndex {
            case 0:
                return CollectionLayoutGenerator.generateArtistSection()
            case 1:
                
                var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                config.backgroundColor = UIColor.systemBackground
                config.headerMode = .supplementary
                config.itemSeparatorHandler = .none

                let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)

                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(34))

                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: HeaderView.sectionHeaderElementKind,
                    alignment: .top)
                
                section.boundarySupplementaryItems = [sectionHeader]
                return section
                
                
            default: return CollectionLayoutGenerator.generatePodcastSection()
            }
        }
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        return layout
    }
}
