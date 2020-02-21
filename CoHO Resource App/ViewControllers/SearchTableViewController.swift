//
//  SearchTableViewController.swift
//  CoHO Resource App
//
//  Created by Jasper on 11/5/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
	
	var searchController: UISearchController!
    
    var searchResultsController: SearchResultsTableViewController!
		
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.definesPresentationContext = true
		
		let backgroundImage = UIImage(named: "blueyellowbkgd4")
		let imageView = UIImageView(image: backgroundImage)
		self.tableView.backgroundView = imageView
		imageView.contentMode = .scaleAspectFill
		
        tableView.separatorStyle = .none
        self.tableView.keyboardDismissMode = .onDrag
        
		buildSearchBar()
    }
	
	func buildSearchBar() {
		// initialize SearchResultsTableViewController
        if #available(iOS 13.0, *) {
            self.searchResultsController = self.storyboard?.instantiateViewController(identifier: "searchResultsTableViewController") as? SearchResultsTableViewController
        } else {
            self.searchResultsController = self.storyboard?.instantiateViewController(withIdentifier: "searchResultsTableViewController") as? SearchResultsTableViewController
        }
        
        // send navigation controller because the searchResultsController has no nav controller
        searchResultsController.navCon = self.navigationController
        searchController = UISearchController(searchResultsController: self.searchResultsController)
		
        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self.searchResultsController
	}

    // MARK: - Table view data source
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "separator", for: indexPath)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 0
	}
}

//extension SearchTableViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//    }
//}
