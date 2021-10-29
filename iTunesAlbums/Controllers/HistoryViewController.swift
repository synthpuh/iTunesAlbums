//
//  HistoryViewController.swift
//  iTunesAlbums
//
//  Created by Ольга Шубина on 26.10.2021.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var searchHistory: [String] {
        get {
            return AppDelegate().userDefaults.object(forKey: "searchHistory") as? [String] ?? []
        }
        set {
            historyTableView.reloadData()
        }
    }

    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTableView.delegate = self
        historyTableView.delegate = self
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") else { return UITableViewCell() }
        
        cell.textLabel?.text = searchHistory[searchHistory.count - indexPath.row - 1]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let vc = self.tabBarController?.viewControllers?[0] as? SearchViewController {
            
            vc.searchBar.text = searchHistory[indexPath.row]
            vc.searchBarSearchButtonClicked(vc.searchBar)
            self.tabBarController?.selectedIndex = 0
        }
    }
}
