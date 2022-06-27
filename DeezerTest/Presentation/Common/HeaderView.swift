//
//  DZHeaderView.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 21/06/22.
//

import Foundation
import UIKit

class HeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    static let reuseIdentifier = "header-reuse-identifier"
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .headerFont
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    // MARK: - Initialization
    
    ///Configures header view and activates constraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Extension Configure

extension HeaderView {
    
    func configure() {
        
        backgroundColor = .black.withAlphaComponent(0.05)
        addSubview(headerLabel)
        let inset = CGFloat(2)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
