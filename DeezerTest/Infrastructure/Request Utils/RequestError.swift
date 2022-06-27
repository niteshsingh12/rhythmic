//
//  RequestError.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 26/06/22.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidRequest
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case clientError(_ code: Int)
    case serverError(_ code: Int)
    case decodingError
    case urlSessionFailed(_ error: URLError)
    case unknownError
}
