//
//  ImageRepository.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 26/06/22.
//

import Combine
import UIKit

protocol ImageRepository {
    func loadImage(urlString: String) -> Future<UIImage, Error>
    func cancelLoad(_ urlString: String)
}
