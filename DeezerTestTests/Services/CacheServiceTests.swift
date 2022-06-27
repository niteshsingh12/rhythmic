//
//  CacheServiceTests.swift
//  DeezerTestTests
//
//  Created by Nitesh Singh on 27/06/22.
//

import Foundation
import XCTest
@testable import DeezerTest

class CacheServiceTests: XCTestCase {
    
    func test_imageSaveAndFetch() {
        
        guard let image = UIImage(named: "deezer") else {
            XCTFail("Failed to load image")
            return
        }
        CacheService.shared.save(image: image, forKey: "deezer")
        
        let fetchedImg = CacheService.shared.fetch(forKey: "deezer")
        XCTAssertNotNil(fetchedImg)
    }
}
