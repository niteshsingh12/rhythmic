//
//  UIFont+Extension.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 27/06/22.
//

import UIKit

extension UIFont {
    static var cellTitleFont: UIFont = {
        return UIFont.systemFont(ofSize: 14, weight: .medium)
    }()
    
    static var cellSubtitleFont: UIFont = {
        return UIFont.systemFont(ofSize: 12, weight: .semibold)
    }()
    
    static var cellBodyFont: UIFont = {
        return UIFont.systemFont(ofSize: 12, weight: .regular)
    }()
    
    static var headlineFont: UIFont = {
        return UIFont.preferredFont(forTextStyle: .headline)
    }()
    
    static var subHeadlineFont: UIFont = {
        return UIFont.preferredFont(forTextStyle: .subheadline)
    }()
    
    static var viewLargeFont: UIFont = {
        return UIFont.systemFont(ofSize: 40, weight: .bold)
    }()
    
    static var viewMediumFont: UIFont = {
        return UIFont.systemFont(ofSize: 16, weight: .semibold)
    }()
    
    static var headerFont: UIFont = {
        return UIFont.systemFont(ofSize: 16, weight: .bold)
    }()
}
