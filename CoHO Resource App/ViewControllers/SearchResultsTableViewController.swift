//
//  SearchResultsTableViewController.swift
//  CoHO Resource App
//
//  Created by Jasper on 2/19/20.
//  Copyright © 2020 Jasper. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {

    var filteredResources = [Resource]()
    var navCon: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.keyboardDismissMode = .onDrag
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResource: Resource = filteredResources[indexPath.row]
        
        print("hey we selected a row")
        
        // Set up the detail view controller to push.
        let resourceVC = ResourceTableViewController.vcForResource(selectedResource)
        resourceVC.buildCells()
        resourceVC.navigationItem.title = selectedResource.name
        
        self.presentingViewController?.navigationController?.pushViewController(resourceVC, animated: true)

        tableView.deselectRow(at: indexPath, animated: false)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let cell = sender as? CategoryCellTableViewCell {
//            if let destination = segue.destination as? ResourceTableViewController {
//                destination.resource = cell.resource
//                destination.navigationItem.title = cell.resource.name
//                destination.buildCells()
//            }
//        }
//    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
            guard let resources = (UIApplication.shared.delegate as? AppDelegate)?.cohoData?.resources else {
                return
            }

            // search controller clears text when tapping out of the search bar
//            if !searchController.isActive {
//                return
//            }
            
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

extension SearchResultsTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
