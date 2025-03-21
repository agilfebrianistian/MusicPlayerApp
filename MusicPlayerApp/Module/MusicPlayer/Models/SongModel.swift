//
//  SongModel.swift
//  MusicPlayerApp
//
//  Created by Agil Febrianistian on 21/03/25.
//

import Foundation


struct SongParameter: Codable {
    let term: String
    var entity: String = "song"
    var attribute: String = "allArtistTerm"
}

struct SongModel: Codable {
    let resultCount: Int
    var results: [SongModelResult]?
}

struct SongModelResult: Codable {
    let artistName, collectionName, trackName: String?
    let previewURL: String?
    let artworkUrl100: String?
    var isPlaying:Bool?

    enum CodingKeys: String, CodingKey {
        case artistName, collectionName, trackName
        case previewURL = "previewUrl"
        case artworkUrl100
        case isPlaying
    }
}
