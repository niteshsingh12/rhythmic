//
//  PodcastCell.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 22/06/22.
//

import Foundation
import UIKit
import Combine

final class PodcastCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifer = "podcast-cell-reuse-identifier"
    
    lazy var podcastNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .cellTitleFont
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    lazy var podcastDescLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .cellSubtitleFont
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    lazy var podcastImageView: UIImageView = {
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
    
    var viewModel: PodcastCellViewModel! {
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
    
    func injectDependencies(imageRepository: ImageRepository, viewModel: PodcastCellViewModel) {
        self.imageRepository = imageRepository
        self.viewModel = viewModel
    }
    
    ///Whenever cell is reused, call closure to cancel image load if ongoing and make imgeview as nil
    override func prepareForReuse() {
        super.prepareForReuse()
        podcastImageView.image = .deezer
    }
    
    override func layoutSubviews() {
        
        //only apply the blur if the user hasn't disabled transparency effects
        if podcastImageView.subviews.filter( {$0.isKind(of: UIVisualEffectView.self)}).isEmpty {
            podcastImageView.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = CGRect(x: 0, y: self.frame.height - 60.0, width: self.frame.width, height: 60.0)
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            podcastImageView.addSubview(blurEffectView)
        }
    }
    
    // MARK: - Methods
    
    ///Bind viewmodel to view, to listen to any changes made in viewmodel and update cell
    private func setupBindings() {
        
        viewModel.podcastPublisher
            .sink(receiveValue: { (podcast) in
                self.podcastNameLabel.text = podcast.title
                self.podcastDescLabel.text = podcast.description ?? ""
                self.fetchImage(urlString: podcast.picture_big!)
            })
            .store(in: &bindings)
    }
    
    private func fetchImage(urlString: String) {
        
        imageRepository?.loadImage(urlString: urlString)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { (image) in
                self.podcastImageView.image = image
            })
            .store(in: &self.bindings)
    }
    
    private func setup() {
        
        let subviews = [podcastImageView, podcastNameLabel, podcastDescLabel]
        subviews.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            podcastImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            podcastImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            podcastImageView.topAnchor.constraint(equalTo: self.topAnchor),
            podcastImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            podcastNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            podcastNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            podcastNameLabel.heightAnchor.constraint(equalToConstant: 30.0),
            podcastNameLabel.bottomAnchor.constraint(equalTo: podcastDescLabel.topAnchor, constant: 0.0),
                        
            podcastDescLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            podcastDescLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            podcastDescLabel.heightAnchor.constraint(equalToConstant: 20.0),
            podcastDescLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0),
        ])
    }
}
