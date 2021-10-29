//
//  AlbumCollectionViewCell.swift
//  iTunesAlbums
//
//  Created by Ольга Шубина on 26.10.2021.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(album: AlbumModel) {
        
        albumNameLabel.text = album.collectionName
        
        let cacheItemNumber = NSNumber(value: album.collectionId)
        
        if let cachedImage = MainTabBarController.cache.object(forKey: cacheItemNumber) {
            
            print("Using a cached image for item: \(cacheItemNumber)")
            albumImage.image = cachedImage
        } else {
            
            guard let artworkUrl = album.artworkUrl100?.replacingOccurrences(of: "100x100", with: "300x300") else { return }
            
            guard let imageURL = URL(string: artworkUrl) else { return }
            
            do {
                let data = try Data(contentsOf: imageURL)
                
                if let image = UIImage(data: data) {
                    albumImage.image = image
                    MainTabBarController.cache.setObject(image, forKey: cacheItemNumber)
                }
            } catch {
                print("Error uploading image: \(error)")
            }
        }
    }
}
