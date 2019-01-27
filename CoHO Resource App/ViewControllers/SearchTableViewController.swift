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
	
	var filteredResources = [Resource]()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.definesPresentationContext = true
		
		let backgroundImage = UIImage(named: "blueyellowbkgd4")
		let imageView = UIImageView(image: backgroundImage)
		self.tableView.backgroundView = imageView
		imageView.contentMode = .scaleAspectFill
		tableView.backgroundColor = UIColor.clear
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		
		self.tableView.separatorStyle = .none
		
		tableView.estimatedRowHeight = 100
		tableView.rowHeight = UITableView.automaticDimension
		
		buildSearchBar()
    }
	
	func buildSearchBar() {
		
		searchController = UISearchController(searchResultsController: nil)
		
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
		searchController.searchResultsUpdater = self
	}

    // MARK: - Table view data source
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row % 2 == 1 {
			return tableView.dequeueReusableCell(withIdentifier: "separator", for: indexPath)
		}
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryCellTableViewCell
		
		cell.catNameLabel.text = filteredResources[indexPath.row / 2].name
		
		if let image = filteredResources[indexPath.row / 2].categories.first?.iconImage {
			cell.iconView.image = image
			
		}
		
		var catstr = ""
		
		for category in filteredResources[indexPath.row / 2].categories {
			if (indexPath.row / 2 < filteredResources[indexPath.row / 2].categories.count - 1) {
				catstr = "\(catstr)\(category.name), "
			} else {
				catstr = "\(catstr)\(category.name)"
			}
		}
		
		cell.itemsLabel.text = catstr
		
		cell.resource = filteredResources[indexPath.row / 2]
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filteredResources.count * 2 - 1
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row % 2 == 1 {
			return 10
		}
		
		return 100
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let cell = sender as? CategoryCellTableViewCell {
			if let destination = segue.destination as? ResourceTableViewController {
				destination.resource = cell.resource
				destination.navigationItem.title = cell.resource.name
				destination.buildCells()
			}
		}
	}
	
	func searchBarIsEmpty() -> Bool {
		// Returns true if the text is empty or nil
		return searchController.searchBar.text?.isEmpty ?? true
	}
	
	func filterContentForSearchText(_ searchText: String, scope: String = "All") {
		guard let resources = (UIApplication.shared.delegate as? AppDelegate)?.cohoData?.resources else {
			return
		}

		// search controller clears text when tapping out of the search bar
		if !searchController.isActive {
			return
		}
		
		let lowerST = searchText.lowercased()
		
		filteredResources = resources.filter({( resource : Resource ) -> Bool in
			// check category
			for category in resource.categories {
				if category.name.lowercased().contains(lowerST) {
					return true
				}
			}
			
			// check counties
			for county in resource.counties {
				if county.name.lowercased().contains(lowerST) {
					return true
				}
			}
			
			// check name
			if resource.name.lowercased().contains(lowerST) {
				return true
			}
			
			// check tags
			if resource.tags.lowercased().contains(lowerST) {
				return true
			}
			
			// check services
			if resource.services.lowercased().contains(lowerST) {
				return true
			}
			
			// check description
			if resource.desc.lowercased().contains(lowerST) {
				return true
			}
			
			return false
		})
		
		tableView.reloadData()
	}
}

extension SearchTableViewController: UISearchResultsUpdating {
	// MARK: - UISearchResultsUpdating Delegate
	func updateSearchResults(for searchController: UISearchController) {
		filterContentForSearchText(searchController.searchBar.text!)
	}
}
