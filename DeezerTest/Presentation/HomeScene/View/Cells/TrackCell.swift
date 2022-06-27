//
//  TrackCell.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 21/06/22.
//

import Foundation
import UIKit
import Combine

class TrackCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifer = "track-cell-reuse-identifier"
    
    lazy var trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = .deezer
        return imageView
    }()
    
    lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .cellTitleFont
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    lazy var trackArtistLabel: UILabel = {
        let label = UILabel()
        label.font = .cellBodyFont
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    var imageURL = String()
    var imageRepository: ImageRepository?
    private var cancellableSet = Set<AnyCancellable>()
    private var track: Track?
    
    var viewModel: TrackCellViewModel! {
        didSet {
            setupBindings()
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func injectDependencies(imageRepository: ImageRepository, viewModel: TrackCellViewModel) {
        self.imageRepository = imageRepository
        self.viewModel = viewModel
    }
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = .deezer
    }
    
    // MARK: - Methods
    
    private func setupBindings() {
        
        viewModel.trackPublisher
            .sink(receiveValue: { (track) in
                
                self.track = track
                self.trackNameLabel.text = track.title
                self.trackArtistLabel.text = track.artist.name
                self.fetchImage(urlString: track.artist.picture_small!)
            })
            .store(in: &cancellableSet)
    }
    
    private func fetchImage(urlString: String) {
        imageURL = urlString
        
        imageRepository?.loadImage(urlString: urlString)
            .sink(receiveCompletion: { completion in
                
                switch completion {
                case .failure:
                    self.trackImageView.image = .deezer
                default: ()
                }
            }, receiveValue: { (image) in
                self.trackImageView.image = image
            })
            .store(in: &self.cancellableSet)
    }
    
    private func setup() {
        
        let textStackView = UIStackView(arrangedSubviews: [trackNameLabel, trackArtistLabel])
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.distribution = .fillEqually
        
        let stackView = UIStackView(arrangedSubviews: [trackImageView, textStackView])
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            trackImageView.heightAnchor.constraint(equalTo: trackImageView.widthAnchor),
            trackImageView.widthAnchor.constraint(equalTo: trackImageView.heightAnchor),
        ])
    }
}


