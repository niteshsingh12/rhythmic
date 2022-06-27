//
//  Notification+Extension.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 27/06/22.
//

import Foundation

extension Notification.Name {
    static let trackPlayedSuccessfully = Notification.Name("playerDidFinishPlaying:")
    static let trackFailed = Notification.Name("playerFailedToPlayToEndTime:")
    static let newTrackPlayed = Notification.Name("newTrackPlayed:")
}
