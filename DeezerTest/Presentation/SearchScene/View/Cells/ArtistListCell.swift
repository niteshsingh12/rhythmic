//
//  ArtistListCell.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 23/06/22.
//

import Foundation
import UIKit
import Combine

final class TaskManagerListCell: UICollectionViewListCell {
    
    // MARK: - Properties
    
    var artist: Artist?
    var imageRepository: ImageRepository?
    var bindings = Set<AnyCancellable>()
    
    var loadedImage: UIImage? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    func injectDependencies(imageRepository: ImageRepository, artist: Artist) {
        self.imageRepository = imageRepository
        self.artist = artist
        
        if let url = artist.picture_small {
            fetchImage(url: url)
        }
    }
    
    // MARK: - Life Cycle
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var content = UIListContentConfiguration.subtitleCell().updated(for: state)
        content.image = self.loadedImage
        content.text = artist?.name
        
        content.imageProperties.maximumSize = CGSize(width: 40, height: 40)
        content.imageProperties.cornerRadius = 5.0
        content.textProperties.font = .headlineFont
        content.textProperties.color = .label
        content.imageToTextPadding = 10
        content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        self.contentConfiguration = content
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Methods
    
    private func fetchImage(url: String) {
        
        self.loadedImage = .deezer
        
        imageRepository?.loadImage(urlString: url)
            .sink(receiveCompletion: { completion in
            }, receiveValue: { (image) in
                self.loadedImage = image
            })
            .store(in: &self.bindings)
    }
}
