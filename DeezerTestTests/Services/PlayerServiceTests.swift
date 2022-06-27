//
//  PlayerServiceTests.swift
//  DeezerTestTests
//
//  Created by Nitesh Singh on 27/06/22.
//

import Foundation
import XCTest
@testable import DeezerTest

class PlayerServiceTests: XCTestCase {
    
    func test_playTrackFromPreviewURL() {
        AudioPlayerService.shared.play(withStringUrl: "https://cdns-preview-b.dzcdn.net/stream/c-bdab5f5d846a91f14a01b75731dbc22a-7.mp3")
        XCTAssertTrue(AudioPlayerService.shared.isPlaying)
    }
    
    func testPlayThenPause() {
        AudioPlayerService.shared.play(withStringUrl: "https://cdns-preview-b.dzcdn.net/stream/c-bdab5f5d846a91f14a01b75731dbc22a-7.mp3")
        XCTAssertTrue(AudioPlayerService.shared.isPlaying)
        AudioPlayerService.shared.pause()
        XCTAssertFalse(AudioPlayerService.shared.isPlaying)
    }
}
