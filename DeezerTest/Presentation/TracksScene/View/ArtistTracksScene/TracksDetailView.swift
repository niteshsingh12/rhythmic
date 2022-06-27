//
//  TracksDetailView.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 24/06/22.
//

import Foundation
import UIKit

protocol NavigationDelegate: AnyObject {
    func didTapBackButton()
}

final class TracksDetailView: UIView {
    
    // MARK: - Properties
    
    lazy var tracksTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        tableView.bounces = false
        tableView.alwaysBounceVertical = false
        return tableView
    }()
    
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var imageContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .large)
        let image = UIImage(systemName: "arrow.backward.circle.fill", withConfiguration: imageConfiguration)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapBackButton(_:)), for: .allTouchEvents)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var titleVLabel: UILabel = {
        let label = UILabel()
        label.font = .viewLargeFont
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.8
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .viewMediumFont
        label.textColor = .white.withAlphaComponent(0.5)
        label.textAlignment = .left
        return label
    }()
    
    lazy var trackCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.5)
        label.font = .viewMediumFont
        label.textAlignment = .left
        return label
    }()
    
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }()
    
    let gradientLayer = CAGradientLayer()
    
    weak var delegate: NavigationDelegate?
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        setup()
        addGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = imageContentView.frame
    }
    
    // MARK: - Methods
    
    private func setup() {
        
        verticalStackView.addArrangedSubview(titleVLabel)
        verticalStackView.addArrangedSubview(subtitleLabel)
        verticalStackView.addArrangedSubview(trackCountLabel)

        verticalStackView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(tracksTableView)

        tracksTableView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        imageContentView.translatesAutoresizingMaskIntoConstraints = false

        coverImageView.addSubview(verticalStackView)
        coverImageView.addSubview(backButton)
        
        imageContentView.addSubview(coverImageView)
        tracksTableView.addSubview(imageContentView)
        
        NSLayoutConstraint.activate([

            tracksTableView.topAnchor.constraint(equalTo: self.topAnchor),
            tracksTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tracksTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tracksTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            imageContentView.heightAnchor.constraint(equalToConstant: 300),
            imageContentView.widthAnchor.constraint(equalTo: self.tracksTableView.widthAnchor),
            
            coverImageView.topAnchor.constraint(equalTo: imageContentView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: imageContentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: imageContentView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: imageContentView.bottomAnchor, constant: -20),

            backButton.heightAnchor.constraint(equalToConstant: 50.0),
            backButton.widthAnchor.constraint(equalToConstant: 50.0),

            verticalStackView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor, constant: 10),
            verticalStackView.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: -100),
            verticalStackView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: -30),
        ])
        coverImageView.image = .deezer
    }
    
    func addGradient() {

        gradientLayer.colors = [UIColor.black, UIColor.clear, UIColor.black].map{ $0.cgColor }
        gradientLayer.locations = [0.0, 0.1, 0.7, 1.0]
        coverImageView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Actions
    
    @objc func didTapBackButton(_ sender: UIButton) {
        delegate?.didTapBackButton()
    }
}
