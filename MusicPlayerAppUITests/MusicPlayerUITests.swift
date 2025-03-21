//
//  MusicPlayerUITests.swift
//  MusicPlayerAppUITests
//
//  Created by Agil Febrianistian on 22/03/25.
//

import XCTest
@testable import MusicPlayerApp

class MusicPlayerUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    // Test if the music list loads
    func testMusicListLoads() {
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "Music list did not load.")
    }
    
    // Test if tapping a song starts playing
    func testPlaySong() {
        let firstCell = app.tables.cells.element(boundBy: 0)
        firstCell.tap()
        
        let playingIndicator = firstCell.images["musicAnimation"]
        XCTAssertFalse(playingIndicator.isHittable, "Music animation should be visible.")
    }
    
    // Test play/pause toggle
    func testPauseAndResumeSong() {
        let playButton = app.buttons["playButton"]
        
        playButton.tap()  // Start playing
        XCTAssertEqual(playButton.label, "pause", "Play button did not switch to pause.")
    }
    
    // Test Next & Previous song
    func testNextAndPreviousSong() {
        let firstCell = app.tables.cells.element(boundBy: 0)
        let secondCell = app.tables.cells.element(boundBy: 1)
        
        firstCell.tap()
        app.buttons["nextButton"].tap()
        let playingIndicator = secondCell.images["musicAnimation"]
        XCTAssertFalse(playingIndicator.isHittable, "Music animation should be visible.")

        app.buttons["previousButton"].tap()
        let playingIndicator2 = firstCell.images["musicAnimation"]
        XCTAssertFalse(playingIndicator2.isHittable, "Music animation should be visible.")
    }
    
    // Test Search Functionality
    func testSearchMusic() {
        let searchBar = app.searchFields.element
        searchBar.tap()
        searchBar.typeText("Dewa 19")
        app.keyboards.buttons["Search"].tap()
        
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "Search results did not load.")
    }
    
    // Test Seek Slider
    func testSeekSong() {
        let slider = app.sliders["songSlider"]
        XCTAssertTrue(slider.exists, "Seek slider not found.")
        
        slider.adjust(toNormalizedSliderPosition: 0.5) // Seek to middle
        
        sleep(1)
        
        // Get the slider's actual value (expected range: 0.0 - 1.0)
        let sliderValue = slider.normalizedSliderPosition
        XCTAssertTrue(abs(sliderValue - 0.5) < 0.05, "Seek did not update correctly. Expected ~0.5, got \(sliderValue)")
        
    }
}
