//
//  AudioPlayerService.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 25/06/22.
//

import AVFoundation

enum AudioError: Error {
    case playError(Error)
}

protocol AudioPlayerServiceProtocol {
    
    // MARK: - Properties
    
    var isPlaying: Bool { get }
    
    // MARK: - Methods
    
    func play(withStringUrl stringUrl: String)
    func pause()
}

final class AudioPlayerService: NSObject, AudioPlayerServiceProtocol {
    
    // MARK: - Properties
    
    static let shared: AudioPlayerServiceProtocol = AudioPlayerService()
    
    var isPlaying: Bool {
        return (player?.timeControlStatus == AVPlayer.TimeControlStatus.playing) || (self.player?.rate != 0 && self.player?.error == nil)
    }
    
    private var player: AVPlayer?
    
    // MARK: - Methods
    
    func play(withStringUrl stringUrl: String)  {
        
        guard let url = URL(string: stringUrl) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
             print("Audio Error")
        }
        
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        self.player  = AVPlayer(playerItem: playerItem)
        self.player?.play()
        
        addObservers(for: playerItem)
    }
                                               
    func pause() {
        self.player?.pause()
    }
}
