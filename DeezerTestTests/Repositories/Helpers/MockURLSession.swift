//
//  MockURLSession.swift
//  DeezerTestTests
//
//  Created by Nitesh Singh on 24/06/22.
//

import Foundation

class MockURLSession: URLSession {
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    override func dataTask(with request: URLRequest,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = self.data
        let response = self.response
        let error = self.error
        return MockURLSessionDataTask {
            completionHandler(data, response, error)
        }
    }
}
