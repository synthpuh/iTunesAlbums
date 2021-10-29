//
//  SearchViewController.swift
//  iTunesAlbums
//
//  Created by Ольга Шубина on 26.10.2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    let networkService = NetworkService()
    
    var searchViewModel: [AlbumModel] = []
    var timer = Timer()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        let nib = UINib(nibName: "AlbumCollectionViewCell", bundle: nil)
        
        collectionView.register(nib, forCellWithReuseIdentifier: "reuseID")
        
        activityIndicator.hidesWhenStopped = true
    }
}

//MARK: - Search Bar Delegate methods

extension SearchViewController: UISearchBarDelegate {
    
    // Show cancel button when searchbar is focused on
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    // Hide keyboard when cancel or search tapped
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.searchTextField.text = ""
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        
        if let vc = self.tabBarController?.viewControllers?[1] as? HistoryViewController, let searchText = searchBar.text {
            var newSearchHistory: [String] = []
            newSearchHistory.append(contentsOf: vc.searchHistory)
            newSearchHistory.append(searchText)
            AppDelegate().userDefaults.set(newSearchHistory, forKey: "searchHistory")
        }
        
        searchViewModel = []
        
        activityIndicator.startAnimating()
        
        networkService.fetchInfo(searchText: searchBar.text ?? "", lookupTracks: false) { [weak self] searchResponseModel in
            
            if let searchResponseModel = searchResponseModel as? SearchResponseModel {
                DispatchQueue.main.async {
                    
                    self?.searchViewModel = searchResponseModel.results
                    self?.searchViewModel.sort(by: { album1, album2 in
                        album1.collectionName < album2.collectionName
                    })
                    self?.collectionView.reloadData()
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        
    }
}

//MARK: - CollectionView Delegate and Datasource methods

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
        
        cell.set(album: searchViewModel[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        self.searchBar.endEditing(true)
        
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        let albumDetailView = Bundle.main.loadNibNamed("AlbumDetailView", owner: self, options: nil)?.first as! AlbumDetailView
        albumDetailView.frame.size.width = UIScreen.main.bounds.width
        albumDetailView.frame.size.height = UIScreen.main.bounds.height
        
        albumDetailView.set(album: searchViewModel[indexPath.row])
        
        keyWindow?.addSubview(albumDetailView)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2 + 25)
    }
    
}

