//
//  MusicViewModelTest.swift
//  MusicPlayerAppTests
//
//  Created by Agil Febrianistian on 22/03/25.
//

import XCTest
import AVFoundation
@testable import MusicPlayerApp

final class MusicViewModelTest: XCTestCase {
    
    var viewModel: MusicViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = MusicViewModel()
        
        // Mocking a song list
        let mockSongs = SongModel(resultCount: 3, results: [SongModelResult(artistName: "Dewa 19", collectionName: "Terbaik Terbaik",
                                                                            trackName: "Cukup Siti Nurbaya",
                                                                            previewURL: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/d8/80/5b/d8805bb5-3a42-a79d-45cf-dbe8923c2001/mzaf_11828713234194939114.plus.aac.p.m4a",
                                                                            artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music/v4/ec/2f/0c/ec2f0cc7-6623-35eb-198a-8dec6d23c303/Dewa_19_terbaik-terbaik.jpg/100x100bb.jpg"),
                                                            SongModelResult(artistName: "Dewa 19", collectionName: "Pandawa Lima",
                                                                            trackName: "Kamulah Satu - Satunya",
                                                                            previewURL: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/a0/03/66/a00366c9-e0a8-2548-3ac3-d9c4aa8bfa16/mzaf_2138273639103779979.plus.aac.p.m4a",
                                                                            artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music/v4/2f/bc/bb/2fbcbbb2-9fd1-a874-8651-06bb5e54c094/Dwwa_19_Pandawa_5.jpg/100x100bb.jpg"),
                                                            SongModelResult(artistName: "Dewa 19", collectionName: "Terbaik Terbaik",
                                                                            trackName: "Jalan Kita Masih Panjang",
                                                                            previewURL: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/20/26/a7/2026a73b-1ea5-27af-b8ed-4f9bc7f9e441/mzaf_15695471524238135586.plus.aac.p.m4a",
                                                                            artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music/v4/ec/2f/0c/ec2f0cc7-6623-35eb-198a-8dec6d23c303/Dewa_19_terbaik-terbaik.jpg/100x100bb.jpg")])
        
        viewModel.song = mockSongs
    }
    
    override func tearDown() {
        viewModel = nil
        //        mockPlayer = nil
        super.tearDown()
    }
    
    // Test playOrPauseSong function
    func testPlayOrPauseSong() {
        viewModel.playOrPauseSong(at: 0)
        XCTAssertEqual(viewModel.currentPlayingIndex, 0)
        XCTAssertEqual(viewModel.song?.results?[0].isPlaying, true)
    }
    
    // Test pauseSong function
    func testPauseSong() {
        viewModel.playOrPauseSong(at: 0)
        viewModel.pauseSong()
        
        XCTAssertEqual(viewModel.song?.results?[0].isPlaying, false)
        XCTAssertTrue(viewModel.isPaused)
    }
    
    // Test resumeSong function
    func testResumeSong() {
        viewModel.playOrPauseSong(at: 0)
        viewModel.pauseSong()
        viewModel.resumeSong()
        
        XCTAssertEqual(viewModel.song?.results?[0].isPlaying, true)
        XCTAssertFalse(viewModel.isPaused)
    }
    
    // Test stopSong function
    func testStopSong() {
        viewModel.playOrPauseSong(at: 0)
        viewModel.stopSong()
        
        XCTAssertNil(viewModel.currentPlayingIndex)
        XCTAssertEqual(viewModel.song?.results?[0].isPlaying, false)
    }
    
    // Test playNext function
    func testPlayNext() {
        viewModel.playOrPauseSong(at: 0)
        viewModel.playNext()
        
        XCTAssertEqual(viewModel.currentPlayingIndex, 1)
        XCTAssertEqual(viewModel.song?.results?[1].isPlaying, true)
    }
    
    // Test playPrevious function
    func testPlayPrevious() {
        viewModel.playOrPauseSong(at: 1)
        viewModel.playPrevious()
        
        XCTAssertEqual(viewModel.currentPlayingIndex, 0)
        XCTAssertEqual(viewModel.song?.results?[0].isPlaying, true)
    }
        
    // Test network fetch with success
    func testFetchSongList_Success() {
        let expectation = self.expectation(description: "Fetch Songs Successfully")
        
        viewModel.onDataUpdated = {
            XCTAssertNotNil(self.viewModel.song)
            expectation.fulfill()
        }
        
        let mockParam = SongParameter(term: "Dewa 19")
        viewModel.fetchSongList(param: mockParam)
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}

