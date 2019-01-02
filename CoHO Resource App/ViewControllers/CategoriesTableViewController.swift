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

//        cell.backgroundColor = UIColor(red: 30/255, green: 50/255, blue: 49/255, alpha: 0.80)
        // Configure the cell...

        return cell
    }
 

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
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
