//
//  MiniPlayViewController.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 25/06/22.
//

import Foundation
import UIKit

protocol TrackSubscriber: AnyObject {
    func configure(track: Track?)
}

class MiniPlayerViewController: UIViewController, TrackSubscriber {

  // MARK: - Properties
    
    lazy var thumbImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = .deezer
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    lazy var trackTitle: UILabel = {
        let label = UILabel()
        label.font = .headlineFont
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var trackArtist: UILabel = {
        let label = UILabel()
        label.font = .subHeadlineFont
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .large)
        let image = UIImage(systemName: "pause.fill", withConfiguration: imageConfiguration)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        return button
    }()

    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 10
        return stackView
    }()

    lazy var dataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    var isPlaying: Bool = true {
        
        didSet {
            if isPlaying {
                playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                trackViewModel?.playTrack()
                
            } else {
                playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                trackViewModel?.pauseTrack()
            }
        }
    }
    
    var trackViewModel: TrackViewModel?

  // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        mainStackView.addArrangedSubview(thumbImage)
        mainStackView.addArrangedSubview(dataStackView)
        mainStackView.addArrangedSubview(playButton)
        dataStackView.addArrangedSubview(trackTitle)
        dataStackView.addArrangedSubview(trackArtist)
        
        let subviews = [mainStackView, playButton, thumbImage]
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        self.view.addSubview(blurView)
        self.blurView.contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: self.view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mainStackView.topAnchor.constraint(equalTo: self.blurView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.blurView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.blurView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.blurView.bottomAnchor),
            thumbImage.widthAnchor.constraint(equalToConstant: 50),
            thumbImage.heightAnchor.constraint(equalToConstant: 50),
            playButton.widthAnchor.constraint(equalToConstant: 40),
            playButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(trackPlayedSuccessfully(_:)), name: .trackPlayedSuccessfully, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(trackFailed(_:)), name: .trackFailed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(configureNewTrack(_:)), name: .newTrackPlayed, object: nil)
    }
    
    // MARK: - Observer Methods
    
    @objc func trackPlayedSuccessfully(_ sender: Any) {
        isPlaying = false
    }
    
    @objc func trackFailed(_ sender: Any) {
        isPlaying = false
    }
    
    @objc func didTapPlayButton() {
        isPlaying = !isPlaying
    }
    
    @objc func configureNewTrack(_ notification: NSNotification) {
        if let track = notification.userInfo?["track"] as? Track {
            configure(track: track)
        }
    }
}

// MARK: - Track Configuration

extension MiniPlayerViewController {
    
    func configure(track: Track?) {
        if let track = track {
            trackTitle.text = track.title
            trackArtist.text = track.artist.name
        }
        isPlaying = true
        trackViewModel?.currentTrack = track
    }
}
