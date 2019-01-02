//
//  CategoriesTableViewController.swift
//  CoHO Resource App
//
//  Created by Jasper on 10/1/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class CountiesTableViewController: UITableViewController {
	
	var counties: [County]?
	
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
		
		counties = (UIApplication.shared.delegate as? AppDelegate)?.cohoData?.counties
		
		//		let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
		//		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		//		blurEffectView.frame =  (self.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -10).offsetBy(dx: 0, dy: -10))!
		//		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		//		self.navigationController?.navigationBar.addSubview(blurEffectView)
		//		self.navigationController?.navigationBar.sendSubviewToBack(blurEffectView)
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		if self.counties != nil {
			return self.counties!.count * 2 - 1
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
			let countyCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryCellTableViewCell
			if counties != nil {
				countyCell.populateWithData(level: counties![indexPath.row / 2])
			}
			
			cell = countyCell
		} else {
			cell = tableView.dequeueReusableCell(withIdentifier: "separator", for: indexPath)
		}
		
		//        cell.backgroundColor = UIColor(red: 30/255, green: 50/255, blue: 49/255, alpha: 0.80)
		// Configure the cell...
		
		return cell
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
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
		if let cell = sender as? CategoryCellTableViewCell {
			if let vc = segue.destination as? ResourceListTableViewController {
				vc.resources = cell.level.resources
			}
		}
	}
	
}
