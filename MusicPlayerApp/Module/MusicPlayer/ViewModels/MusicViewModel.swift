//
//  MusicViewModel.swift
//  MusicPlayerApp
//
//  Created by Agil Febrianistian on 21/03/25.
//

import Foundation
import AVFoundation

class MusicViewModel {
    
    var currentPlayingIndex: Int? = nil
    var player: AVPlayer?
    var song:SongModel?
    var isPaused: Bool = false
    var timer: Timer?
    
    var onDataUpdated: (() -> Void)?  // Notify UI when data changes
    var onShowAlert: ((NetworkError) -> Void)?  // Notify UI when an error occurs
    var onProgressUpdate: ((Float) -> Void)? // Closure to update slider progress
    
    func playOrPauseSong(at index: Int) {
        if currentPlayingIndex == index {
            if isPaused {
                resumeSong()
            } else {
                pauseSong()
            }
            return
        }
        
        stopSong()
        
        guard index >= 0, index < song?.results?.count ?? 0 else { return } // Ensure valid index
        
        let song = song?.results?[index]
        if let url = URL(string: song?.previewURL ?? "") {
            player = AVPlayer(url: url)
            player?.play()
            self.song?.results?[index].isPlaying = true
            currentPlayingIndex = index
            startProgressTracking()
        }
        onDataUpdated?()
    }
    
    func stopSong() {
        guard let currentIndex = currentPlayingIndex else { return }
        self.song?.results?[currentIndex].isPlaying = false
        player?.pause()
        player = nil
        currentPlayingIndex = nil
        isPaused = false
        onDataUpdated?()
    }
    
    func pauseSong() {
        guard let currentIndex = currentPlayingIndex else { return }
        player?.pause()
        song?.results?[currentIndex].isPlaying = false
        isPaused = true
        onDataUpdated?()
    }
    
    func resumeSong() {
        guard let currentIndex = currentPlayingIndex else { return }
        player?.play()
        song?.results?[currentIndex].isPlaying = true
        isPaused = false
        startProgressTracking()
        onDataUpdated?()
    }
    
    func playNext() {
        guard let currentIndex = currentPlayingIndex else { return }
        guard (currentPlayingIndex ?? 0) != ((self.song?.results?.count ?? 0) - 1) else { return }
        playOrPauseSong(at: currentIndex + 1)
    }
    
    func playPrevious() {
        guard let currentIndex = currentPlayingIndex else { return }
        guard (currentPlayingIndex ?? 0) != 0 else { return }
        playOrPauseSong(at: currentIndex - 1)
    }
    
    func startProgressTracking() {
        stopProgressTracking() // Ensure no duplicate timers
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let player = self?.player, let duration = player.currentItem?.duration.seconds, duration > 0 else { return }
            let currentTime = player.currentTime().seconds
            let progress = Float(currentTime / duration)
            self?.onProgressUpdate?(progress) // Notify UI to update slider
        }
    }
    
    // Function to stop tracking the song progress
    func stopProgressTracking() {
        timer?.invalidate()
        timer = nil
    }
    
    // Function to seek song to a specific position
    func seekTo(position: Float) {
        guard let player = player, let duration = player.currentItem?.duration.seconds, duration > 0 else { return }
        let newTime = duration * Double(position)
        let time = CMTime(seconds: newTime, preferredTimescale: 1)
        player.seek(to: time)
    }
    
    func fetchSongList(param:SongParameter) {
        let target = NetworkAPI.getSongList(param: param)
        let future = NetworkFuture<Data>()
        future.request(target: target)
            .done { [weak self] dic in
                let decoder = JSONDecoder()
                let result = try decoder.decode(SongModel.self, from: dic)
                self?.song = result
                DispatchQueue.main.async {
                    self?.onDataUpdated?()
                }
            }.catch { [weak self] error in
                self?.onShowAlert?(error as? NetworkError ?? NetworkError())
            }
    }
}
