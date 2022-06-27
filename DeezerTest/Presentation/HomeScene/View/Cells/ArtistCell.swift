//
//  ArtistCell.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation
import UIKit
import Combine

final class ArtistCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    static let reuseIdentifer = "artist-cell-reuse-identifier"
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .cellTitleFont
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    lazy var artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = .deezer
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var bindings = Set<AnyCancellable>()
    
    var imageURL = String()
    
    var imageRepository: ImageRepository?
    
    var viewModel: ArtistCellViewModel! {
        didSet {
            setupBindings()
        }
    }
    
    var onReuse: () -> Void = {}
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func injectDependencies(imageRepository: ImageRepository, viewModel: ArtistCellViewModel) {
        self.imageRepository = imageRepository
        self.viewModel = viewModel
    }
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
        imageRepository?.cancelLoad(imageURL)
        artistImageView.image = .deezer
    }
    
    override func layoutSubviews() {
        artistImageView.layer.cornerRadius = artistImageView.frame.height / 2
    }
    
    override func layoutIfNeeded() {
        artistImageView.layer.cornerRadius = artistImageView.frame.height / 2
    }
    
    //MARK: - Methods
    
    ///Bind viewmodel to view, to listen to any changes made in viewmodel and update cell
    private func setupBindings() {
        
        viewModel.artistPublisher
            .sink(receiveValue: { (artist) in
                self.artistNameLabel.text = artist.name
                self.fetchImage(urlString: artist.picture_medium!)
            })
            .store(in: &bindings)
    }
    
    private func fetchImage(urlString: String) {

        imageURL = urlString
        
        imageRepository?.loadImage(urlString: urlString)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { (image) in
                self.artistImageView.image = image
            })
            .store(in: &self.bindings)
    }
    
    private func setup() {
        
        let subviews = [artistNameLabel, artistImageView]
        subviews.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            artistNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            artistNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            artistNameLabel.heightAnchor.constraint(equalToConstant: 20.0),
            artistNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
            
            artistImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            artistImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            artistImageView.bottomAnchor.constraint(equalTo: self.artistNameLabel.topAnchor, constant: -5.0),
            
            artistImageView.heightAnchor.constraint(equalTo: artistImageView.widthAnchor),
            artistImageView.widthAnchor.constraint(equalTo: artistImageView.heightAnchor),
        ])
    }
}

