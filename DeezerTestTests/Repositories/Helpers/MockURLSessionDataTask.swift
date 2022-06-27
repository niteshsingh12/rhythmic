//
//  MockURLSessionDataTask.swift
//  DeezerTestTests
//
//  Created by Nitesh Singh on 24/06/22.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}
