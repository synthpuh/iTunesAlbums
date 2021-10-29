//
//  TracksModel.swift
//  iTunesAlbums
//
//  Created by Ольга Шубина on 27.10.2021.
//

import Foundation

struct TracksModel: SearchResponse {
    
    var results: [Track]
}

struct Track: Decodable {
    
    var trackName: String?
    var trackNumber: Int?
}
