//
//  AlbumDetailView.swift
//  iTunesAlbums
//
//  Created by Ольга Шубина on 26.10.2021.
//

import UIKit

class AlbumDetailView: UIView {
    
    var tracks: [Track]?

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumYear: UILabel!
    @IBOutlet weak var songsList: UITextView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func set(album: AlbumModel) {
        
        albumName.text = album.collectionName
        albumYear.text = String(album.releaseDate?.prefix(4) ?? "")
        
        let cacheItemNumber = NSNumber(value: album.collectionId)
        
        if let cachedImage = MainTabBarController.cache.object(forKey: cacheItemNumber) {
            albumImage.image = cachedImage
        } else {
            print("Error loading image from cache")
        }
        
        let networkService = NetworkService()
        
        networkService.fetchInfo(searchText: String(album.collectionId), lookupTracks: true) { [weak self] tracksModel in
            
            if let tracksModel = tracksModel as? TracksModel {
                DispatchQueue.main.async {
                    
                    self?.tracks = tracksModel.results
                    self?.printSongs()
                    
                }
            }
        }
        
    }
    
    func printSongs() {
        var string = ""
        if let tracks = tracks {
            for track in tracks {
                
                if let trackName = track.trackName, let trackNumber = track.trackNumber {
                    string = string + "\(trackNumber). \(trackName)\n\n"
                }
                
            }
        }
        songsList.text = string
    }
    
    @IBAction func downButtonTapped(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
