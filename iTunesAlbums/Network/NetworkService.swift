//
//  NetworkService.swift
//  iTunesAlbums
//
//  Created by Ольга Шубина on 26.10.2021.
//

import Foundation

class NetworkService {
    
    func fetchInfo(searchText: String, lookupTracks: Bool, completion: @escaping (SearchResponse?) -> Void) {
        
        let searchArray = searchText.map { $0 == " " ? "+" : $0 }
        let searchTextFormatted = String(searchArray)
        
        var searchString: String = ""
        
        if lookupTracks {
            searchString = "https://itunes.apple.com/lookup?id=\(searchTextFormatted)&entity=song&media=music"
        } else {
            searchString = "https://itunes.apple.com/search?term=\(searchTextFormatted)&media=music&entity=album"
        }
        
        guard let url = URL(string: searchString) else { return }
                
        let session = URLSession.shared
        
        session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data {
                
                let decoder = JSONDecoder()
                
                do {
                    if lookupTracks {
                        let objects = try decoder.decode(TracksModel.self, from: data)
                        completion(objects)
                    } else {
                        let objects = try decoder.decode(SearchResponseModel.self, from: data)
                        completion(objects)
                    }
                } catch let jsonError {
                    print("Error decoding JSON: \(jsonError)")
                }
            }
        }.resume()
    }
}
