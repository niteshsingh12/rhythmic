//
//  CacheService.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 22/06/22.
//

import Foundation
import UIKit

protocol CacheServiceProtocol: AnyObject {
    
    // MARK: - Properties
    func save(image: UIImage, forKey key: String)
    func fetch(forKey key: String) -> UIImage?
}

class CacheService: CacheServiceProtocol {
    
    // MARK: - Properties
    
    static let shared: CacheServiceProtocol = CacheService()
    private var imageCache: NSCache<NSString, UIImage>
    
    // MARK: - Initializer
    
    private init() {
        imageCache = NSCache()
    }
    
    // MARK: - Methods
    
    func save(image: UIImage, forKey key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }
    
    func fetch(forKey key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
}
