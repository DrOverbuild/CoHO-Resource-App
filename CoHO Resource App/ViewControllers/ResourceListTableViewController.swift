//
//  ResourceListTableViewController.swift
//  CoHO Resource App
//
//  Created by Jasper on 11/5/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class ResourceListTableViewController: UITableViewController {
	var resources: [Resource]!

    override func viewDidLoad() {
        super.viewDidLoad()
		
//		if let bar = self.navigationController?.navigationBar {
//			bar.isTranslucent = false
//		}
		
		tableView.estimatedRowHeight = 80
		tableView.rowHeight = UITableView.automaticDimension

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
    }

	override func viewWillAppear(_ animated: Bool) {
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resources.count * 2 - 1
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row % 2 == 0 {
      	let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResourceTableViewCell
			cell.label.text = resources[indexPath.row / 2].name
            cell.resource = resources[indexPath.row / 2]
			
			if let cat = resources[indexPath.row / 2].categories.first {
				if let icon = cat.iconImage {
					cell.iconView.image = icon
				}
			}
			
			return cell
		} else {
			return tableView.dequeueReusableCell(withIdentifier: "separator", for: indexPath)
		}
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row % 2 == 0 {
			return 80
		} else {
			return 5
		}
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ResourceTableViewCell {
            if let destination = segue.destination as? ResourceTableViewController {
                destination.resource = cell.resource
                destination.navigationItem.title = cell.resource.name
                destination.buildCells()
            }
        }
    }
	
}
