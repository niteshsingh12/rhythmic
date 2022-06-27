//
//  Album Cell.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 22/06/22.
//

import Foundation
import UIKit
import Combine

final class AlbumCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifer = "album-cell-reuse-identifier"
    
    lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .cellTitleFont
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .cellBodyFont
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    lazy var albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        imageView.image = .deezer
        return imageView
    }()
    
    private var bindings = Set<AnyCancellable>()
    var imageURL = String()
    
    var imageRepository: ImageRepository?
        
    var viewModel: AlbumCellViewModel! {
        didSet {
            setupBindings()
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func injectDependencies(imageRepository: ImageRepository, viewModel: AlbumCellViewModel) {
        self.imageRepository = imageRepository
        self.viewModel = viewModel
    }
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = .deezer
    }
    
    // MARK: - Methods
    
    private func setupBindings() {
        
        viewModel.albumPublisher
            .sink(receiveValue: { (album) in
                self.albumNameLabel.text = album.title
                
                if let artist = album.artist {
                    self.artistNameLabel.text = artist.name
                }
                self.fetchImage(urlString: album.cover_medium!)
            })
            .store(in: &bindings)
    }
    
    private func fetchImage(urlString: String) {
        imageURL = urlString
        
        imageRepository?.loadImage(urlString: urlString)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { (image) in
                self.albumImageView.image = image
            })
            .store(in: &self.bindings)
    }
    
    private func setup() {
        
        let subviews = [albumImageView, albumNameLabel, artistNameLabel]
        subviews.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            albumImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            albumImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            albumImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
            albumImageView.heightAnchor.constraint(equalTo: albumImageView.widthAnchor),
            albumImageView.widthAnchor.constraint(equalTo: albumImageView.heightAnchor),
            
            albumNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            albumNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            albumNameLabel.heightAnchor.constraint(equalToConstant: 20.0),
            albumNameLabel.topAnchor.constraint(equalTo: self.albumImageView.bottomAnchor, constant: 10.0),
            
            artistNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            artistNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            artistNameLabel.heightAnchor.constraint(equalToConstant: 20.0),
            artistNameLabel.topAnchor.constraint(equalTo: self.albumNameLabel.bottomAnchor),
        ])
    }
}
