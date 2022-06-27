//
//  DZImageView.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 22/06/22.
//

import Foundation
import UIKit
import Combine

enum ImageLoadFailure: Error {
    case malformedURL
    case imageNotFound
    case refError
}

class DefaultImageRepository: ImageRepository {
    
    // MARK: - Properties
    
    private var urlString: String?
    private var cancellables = [String: AnyCancellable]()
    private var cancellable: AnyCancellable?
    
    // MARK: - Methods
    
    func loadImage(urlString: String) -> Future<UIImage, Error> {
        
        return Future<UIImage, Error> { [weak self] promise in
            
            self?.urlString = urlString
            
            guard let url = URL(string: urlString) else {
                promise(.failure(ImageLoadFailure.malformedURL))
                return
            }
            
            if let imageFromCache = CacheService.shared.fetch(forKey: urlString) {
                return promise(.success(imageFromCache))
            }
                        
            self?.cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map {UIImage(data: $0.data)}
                .replaceError(with: nil)
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] (image) in
                    
                    defer { self?.cancellables.removeValue(forKey: urlString) }
                    
                    if let image = image {
                        CacheService.shared.save(image: image, forKey: urlString)
                        promise(.success(image))
                    } else {
                        promise(.failure(ImageLoadFailure.imageNotFound))
                    }
                })
            
            self?.cancellables[urlString] = self?.cancellable
        }
    }
    
    func cancelLoad(_ urlString: String) {
        cancellables[urlString]?.cancel()
        cancellables.removeValue(forKey: urlString)
    }
}
