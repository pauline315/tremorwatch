//
//  SearchViewController.swift
//  EarthQuakeMonitoring
//
//  Created by EMTECH MAC on 20/06/2024.
//

import UIKit
import MapKit

class SearchViewController: UITableViewController {
    
    let searchController = UISearchController()
    var matchingLocations: [MKMapItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController? .navigationBar.prefersLargeTitles = true
        title = "Search"
        addSearchController()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func addSearchController() {
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = .systemPurple
        searchController.searchBar.searchTextField.leftView?.tintColor = .systemPurple
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        perFormSearch()
    }
    
    func perFormSearch() {
        guard let searchBarText = searchController.searchBar.text else{
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
             
            if let error = error  {
                print("Search Failed", error)
                return
                
            }
            
            guard let response = response else {
                return
            }
            
            if !searchBarText.isEmpty {
                
                self.matchingLocations = response.mapItems
                self.tableView.reloadData()
            }
            
         }
        
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            matchingLocations = []
            self.tableView.reloadData()
        }
    }
}

extension SearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  matchingLocations.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let location = matchingLocations[indexPath.row].placemark
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
        configuration.imageToTextPadding = 20
        configuration.secondaryText = location.country
        
        configuration.attributedText = NSAttributedString(string: location.name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .bold)])
        
        configuration.image = UIImage(systemName: "location.fill.viewfinder")
        configuration.imageProperties.tintColor = .systemPurple
        
        cell.contentConfiguration = configuration
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
