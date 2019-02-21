//
//  CategoriesTableViewController.swift
//  CoHO Resource App
//
//  Created by Jasper on 10/1/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
	
	var categories: [Category]?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

		refreshControl = UIRefreshControl()
		refreshControl!.addTarget(self, action: #selector(updateData(_:)), for: .valueChanged)
		
		let backgroundImage = UIImage(named: "blueyellowbkgd4")
		let imageView = UIImageView(image: backgroundImage)
		self.tableView.backgroundView = imageView
		tableView.backgroundColor = UIColor.clear
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		imageView.contentMode = .scaleAspectFill
		
		self.tableView.separatorStyle = .none
		
		tableView.estimatedRowHeight = 100
		tableView.rowHeight = UITableView.automaticDimension
		
		categories = (UIApplication.shared.delegate as? AppDelegate)?.cohoData?.categories
    }
    
	@objc private func updateData(_ sender: Any) {
		UserDefaults.standard.removeObject(forKey: "lastUpdated")
		let delegate = UIApplication.shared.delegate! as! AppDelegate
		delegate.api.loadDataFromServer(delegate: delegate)
	}
	
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		if categories != nil {
			return categories!.count * 2 - 1
		} else {
			return 0
		}
    }

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row % 2 == 0 {
			return 100
		} else {
			return 10
		}
	}
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell
		
		if indexPath.row % 2 == 0 {
			let categoryCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryCellTableViewCell
			if categories != nil {
				categoryCell.populateWithData(level: categories![indexPath.row / 2])
			}
			
			cell = categoryCell
		} else {
			cell = tableView.dequeueReusableCell(withIdentifier: "separator", for: indexPath)
		}

        return cell
    }
 

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
		if let cell = sender as? CategoryCellTableViewCell {
			if let vc = segue.destination as? ResourceListTableViewController {
				vc.resources = cell.level.resources
			}
		}
	}
	
}
