//
//  FakeResponseHelper.swift
//  DeezerTestTests
//
//  Created by Nitesh Singh on 24/06/22.
//

import Foundation

class FakeStub {

    // MARK: - Data

    static func generateFakeDataFromJSONWith(fileName: String) -> Data? {
        let bundle = Bundle(for: FakeStub.self)
        let url = bundle.url(forResource: fileName, withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    // MARK: - Response

    static let responsePass = HTTPURLResponse(
        url: URL(string: "https://api.deezer.com/search?q=eminem")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])

    static let responseFail = HTTPURLResponse(
        url: URL(string: "https://api.deezer.com/chart")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])
}
