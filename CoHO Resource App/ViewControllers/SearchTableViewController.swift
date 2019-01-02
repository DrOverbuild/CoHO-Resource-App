//
//  SearchTableViewController.swift
//  CoHO Resource App
//
//  Created by Jasper on 11/5/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		self.definesPresentationContext = true
		
//		if let bar = self.navigationController?.navigationBar{
//			bar.setBackgroundImage(UIImage(), for: .default)
//			bar.shadowImage = UIImage()
//			bar.isTranslucent = true
//		}
		
		let backgroundImage = UIImage(named: "blueyellowbkgd4")
		let imageView = UIImageView(image: backgroundImage)
		self.tableView.backgroundView = imageView
		imageView.contentMode = .scaleAspectFill
		tableView.backgroundColor = UIColor.clear
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		
		self.tableView.separatorStyle = .none
		
		buildSearchBar()
    }
	
	func buildSearchBar() {
		
		
		let searchController = UISearchController(searchResultsController: nil)
//		searchController.obscuresBackgroundDuringPresentation = false

//		searchBar.tintColor = UIColor.white
//		searchBar.barTintColor = UIColor.white
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
//        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 30/255, green: 50/255, blue: 49/255, alpha: 1.0)
//        self.navigationController?.navigationBar.backgroundColor = UIColor(displayP3Red: 30/255, green: 50/255, blue: 49/255, alpha: 1.0)
//        searchController.searchBar.backgroundColor = UIColor(displayP3Red: 30/255, green: 50/255, blue: 49/255, alpha: 1.0)
//        self.navigationController?.navigationBar.isTranslucent = false
//        searchController.searchBar.setBackgroundImage(UIImage(), for: .topAttached, barMetrics: .default)
		
//		self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
	}

    // MARK: - Table view data source
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func viewDidAppear(_ animated: Bool) {
//		self.navigationItem.searchController?.isActive = true
//		self.navigationItem.searchController?.isEditing = true
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
	}
}
