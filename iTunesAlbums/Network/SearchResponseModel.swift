//
//  SearchResponseModel.swift
//  iTunesAlbums
//
//  Created by Ольга Шубина on 26.10.2021.
//

import Foundation

struct SearchResponseModel: SearchResponse {
    
    var results: [AlbumModel]
}

struct AlbumModel: Decodable {
    
    var collectionId: Int
    var collectionName: String
    var artistName: String
    var artworkUrl100: String?
    var releaseDate: String?
}

typealias SearchResponse = Decodable
