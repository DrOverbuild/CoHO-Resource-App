//
//  SettingsTableViewController.swift
//  CoHO Resource App
//
//  Created by Jasper on 2/3/19.
//  Copyright © 2019 Jasper. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

	@IBOutlet weak var acknowledgmentsLabel: UILabel!
	@IBOutlet weak var updateLabel: UILabel!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		tableView.estimatedRowHeight = 53
		tableView.rowHeight = UITableView.automaticDimension
		
		let backgroundImage = UIImage(named: "blueyellowbkgd4")
		let imageView = UIImageView(image: backgroundImage)
		self.tableView.backgroundView = imageView
		imageView.contentMode = .scaleAspectFill
		tableView.backgroundColor = UIColor.clear
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		
		
		self.tableView.separatorStyle = .none
		
		acknowledgmentsLabel.text = "The CoHO Resource App was designed and built by Jasper Reddin.\n\n The Family icon, Plug icon, Business avatars, and Car icon are all designed by Freepik.com and licensed under the Creative Commons 3.0 Attribution License."
		
		if let frequency = UserDefaults.standard.string(forKey: "updateFrequency") {
			updateLabel.text = frequency.localizedCapitalized
		}
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

}
