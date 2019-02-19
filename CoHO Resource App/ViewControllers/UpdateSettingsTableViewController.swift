//
//  UpdateSettingsTableViewController.swift
//  CoHO Resource App
//
//  Created by Jasper on 2/18/19.
//  Copyright © 2019 Jasper. All rights reserved.
//

import UIKit

class UpdateSettingsTableViewController: UITableViewController {

	@IBOutlet weak var startupCell: UITableViewCell!
	@IBOutlet weak var weeklyCell: UITableViewCell!
	@IBOutlet weak var monthlyCell: UITableViewCell!
	
	var allCells: [UITableViewCell] {
		get {
			return [startupCell!, weeklyCell!, monthlyCell!]
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

		let backgroundImage = UIImage(named: "blueyellowbkgd4")
		let imageView = UIImageView(image: backgroundImage)
		self.tableView.backgroundView = imageView
		imageView.contentMode = .scaleAspectFill
		tableView.backgroundColor = UIColor.clear
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		
		
		self.tableView.separatorStyle = .none
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		if let frequency = UserDefaults.standard.string(forKey: "updateFrequency") {
			for cell in allCells {
				if cell.reuseIdentifier == frequency {
					cell.accessoryType = .checkmark
				} else {
					cell.accessoryType = .none
				}
			}
		}
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView.cellForRow(at: indexPath)?.reuseIdentifier != "notafrequency" {
			checkCell(indexPath: indexPath)
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
	}

	func checkCell(indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)!
		
		for updateCell in allCells {
			updateCell.accessoryType = .none
		}
		
		cell.accessoryType = .checkmark
		
		if let prevVC = self.navigationController?.viewControllers[(navigationController?.viewControllers.count ?? 2) - 2] as? SettingsTableViewController {
			prevVC.updateLabel.text = cell.reuseIdentifier!.localizedCapitalized
		}
		
		UserDefaults.standard.set(cell.reuseIdentifier!, forKey: "updateFrequency")
	}
	
}
