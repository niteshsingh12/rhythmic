//
//  PlaylistCell.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 22/06/22.
//

import Foundation
import UIKit
import Combine

final class PlaylistCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifer = "playlist-cell-reuse-identifier"
    
    lazy var playlistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .cellTitleFont
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    lazy var playlistDescLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .cellSubtitleFont
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    lazy var playlistImageView: UIImageView = {
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
    
    var viewModel: PlaylistCellViewModel! {
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
    
    func injectDependencies(imageRepository: ImageRepository, viewModel: PlaylistCellViewModel) {
        self.imageRepository = imageRepository
        self.viewModel = viewModel
    }
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistImageView.image = .deezer
    }
    
    override func layoutSubviews() {
        
        if playlistImageView.subviews.filter( {$0.isKind(of: UIVisualEffectView.self)}).isEmpty {
            playlistImageView.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = CGRect(x: 0, y: self.frame.height - 60.0, width: self.frame.width, height: 60.0)
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            playlistImageView.addSubview(blurEffectView)
        }
    }
    
    // MARK: - Methods
    
    ///Bind viewmodel to view, to listen to any changes made in viewmodel and update cell
    private func setupBindings() {
        
        viewModel.playlistPublisher
            .sink(receiveValue: { (playlist) in
                self.playlistNameLabel.text = playlist.title
                
                if let desc = playlist.description {
                    self.playlistDescLabel.text = desc
                } else if let tracks = playlist.nb_tracks {
                    self.playlistDescLabel.text = "\(tracks) tracks"
                }
                
                self.fetchImage(urlString: playlist.picture_big!)
            })
            .store(in: &bindings)
    }
    
    private func fetchImage(urlString: String) {
        imageURL = urlString
        
        imageRepository?.loadImage(urlString: urlString)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { (image) in
                self.playlistImageView.image = image
            })
            .store(in: &self.bindings)
    }
    
    private func setup() {
        
        let subviews = [playlistImageView, playlistNameLabel, playlistDescLabel]
        subviews.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            playlistImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            playlistImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            playlistImageView.topAnchor.constraint(equalTo: self.topAnchor),
            playlistImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            playlistNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            playlistNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            playlistNameLabel.heightAnchor.constraint(equalToConstant: 30.0),
            playlistNameLabel.bottomAnchor.constraint(equalTo: playlistDescLabel.topAnchor, constant: 0.0),
                        
            playlistDescLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            playlistDescLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            playlistDescLabel.heightAnchor.constraint(equalToConstant: 20.0),
            playlistDescLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0),
        ])
    }
}
