//
//  TrackTableViewCell.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 24/06/22.
//

import Foundation
import UIKit

final class TrackTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifer = "trackplay-cell-reuse-identifier"
        
    lazy var trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    lazy var trackTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .cellTitleFont
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
    lazy var trackArtistsLabel: UILabel = {
        let label = UILabel()
        label.font = .cellBodyFont
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var dataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        stackView.spacing = 5
        return stackView
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        mainStackView.addArrangedSubview(trackImageView)
        mainStackView.addArrangedSubview(dataStackView)
        dataStackView.addArrangedSubview(trackTitleLabel)
        dataStackView.addArrangedSubview(trackArtistsLabel)
        
        let subviews = [mainStackView, dataStackView, trackImageView, trackTitleLabel, trackArtistsLabel]
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        self.contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            trackImageView.widthAnchor.constraint(equalToConstant: 40),
            trackImageView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Methods
    
    func configureDataWith(track: Track) {
        
        trackTitleLabel.text = track.title
        
        var artists = ""
        
        if let contributors = track.contributors {
            artists = contributors.map {$0.name}.joined(separator: ", ")
        } else {
            artists = track.artist.name
        }
        trackArtistsLabel.text = artists
        trackImageView.image = .deezer
    }
}
