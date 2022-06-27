//
//  AudioPlayerService+Observer.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 27/06/22.
//

import Foundation
import AVFoundation

extension AudioPlayerService {
    
    // MARK: - Observers
    
    func addObservers(for item: AVPlayerItem) {
        
        item.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(trackPlaySuccess(_:)), name: .AVPlayerItemDidPlayToEndTime, object: item)
        NotificationCenter.default.addObserver(self, selector: #selector(trackPlayFailure(_:)), name: .AVPlayerItemFailedToPlayToEndTime, object: item)
    }
    
    @objc private func trackPlaySuccess(_ sender: Any) {
        NotificationCenter.default.post(name: .trackPlayedSuccessfully, object: nil)
    }
    
    @objc private func trackPlayFailure(_ sender: Any?) {
        NotificationCenter.default.post(name: .trackFailed, object: nil)
    }
    
    private func handleAVError(error: NSError) {
        trackPlayFailure(nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let playerItem = object as! AVPlayerItem
        if keyPath == "status", playerItem.status == .failed {
            if let error = playerItem.error as NSError? {
                handleAVError(error: error)
            }
        }
    }
}
