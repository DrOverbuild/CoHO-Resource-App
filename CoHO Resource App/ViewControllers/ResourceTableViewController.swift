//
//  ResourceTableViewController.swift
//  CoHO Resource App
//
//  Created by Jasper on 11/23/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit
import CoreLocation
import Down

class ResourceTableViewController: UITableViewController {
	
	var resource: Resource!
	var cells = [UITableViewCell]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		let backgroundImage = UIImage(named: "blueyellowbkgd4")
		let imageView = UIImageView(image: backgroundImage)
		self.tableView.backgroundView = imageView
		imageView.contentMode = .scaleAspectFill
		
		tableView.rowHeight = UITableView.automaticDimension
	}
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            if self.cells.count == 0 {
                self.buildCells()
                self.tableView.reloadData()
            }
        }
    }
	
	func buildCells() {
		cells = []

		// locations section
		if resource.locations.count > 0 { // only add heading cell for locations if location information exists
			cells.append(titleCell(text: "Locations"))
			
			for address in resource.locations {
				cells.append(locationCell(address: address))
			}
		}
		
		// contact section
		if resource.contact.count > 0 { // only add heading cell for contact if contact information exists
			cells.append(titleCell(text: "Contact"))
			for contact in resource.contact {
				cells.append(contactCell(contact: contact))
			}
		}

		// information section
		if !(resource.services.isEmpty && resource.documentation.isEmpty
			&& resource.hours.isEmpty && resource.desc.isEmpty) {
			// only add heading cell for infomration if information exists
			
			cells.append(titleCell(text: "Information"))
		
			if !resource.services.isEmpty {
				cells.append(informationCell(title: "Services", text: resource.services))
			}
			
			if !resource.documentation.isEmpty {
				cells.append(informationCell(title: "Required Documentation", text: resource.documentation))
			}
			
			if !resource.hours.isEmpty {
				cells.append(informationCell(title: "Hours", text: resource.hours))
			}
			
			if !resource.desc.isEmpty {
				let lastCell = informationCell(title: "Description", text: resource.desc)
				lastCell.hideSeparator()
				cells.append(lastCell)
			}
		}
		
		// report function
		let reportCell = tableView.dequeueReusableCell(withIdentifier: "reportCell")!
		cells.append(reportCell)
		
	}
	
	func titleCell(text: String) -> TitleTableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell")! as! TitleTableViewCell
		cell.titleLabel.text = text
		return cell
	}
	
	func informationCell(title: String, text: String) -> InformationTableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell")! as! InformationTableViewCell
		//        cell.
		let down = Down(markdownString: text)
		let downOptions = DownOptions(rawValue: 0) // default options
		let attString = try? down.toAttributedString(downOptions, stylesheet: bodyStylesheet)
		cell.informationLabel.attributedText = attString
		cell.informationTitleLabel.text = title
		//        cell.informationLabel.text = text
		return cell
	}
	
	func locationCell(address: Address) -> LocationTableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")! as! LocationTableViewCell
		//        cell.
		address.get2DCoordinates(locationCompletionHandler: {(cllocation) in
			if let location = cllocation {
				cell.mapCenter = location.coordinate
			}
		})
		
		cell.titleLabel.text = address.desc
		cell.street1.text = address.street1
		
		if (!address.street2.isEmpty) {
			cell.street2.text = address.street2
			cell.city.text = "\(address.city), \(address.state) \(address.zip)"
		} else {
			cell.street2.text = "\(address.city), \(address.state) \(address.zip)"
			cell.city.text = ""
		}
		
		return cell
	}
	
	func contactCell(contact: Contact) -> ContactTableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as! ContactTableViewCell
		cell.contact = contact
		return cell
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
        return cells.count == 0 ? 1 : cells.count
	}
	
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cells.count == 0 {
            let newCell = tableView.dequeueReusableCell(withIdentifier: "loadingCell") as! LoadingTableViewCell
            newCell.activityIndicator.startAnimating()
            return newCell
        }
        
		return cells[indexPath.row]
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let cell = tableView.cellForRow(at: indexPath)
		
		
		if let locCell = cell as? LocationTableViewCell {
			locCell.onTap(viewController: self)
		}
		
		if let conCell = cell as? ContactTableViewCell {
			conCell.onTap(viewController: self)
		}
		
		if let reportCell = cell as? ReportTableViewCell {
			reportCell.onTap(viewController: self)
		}
	}
    
    class func vcForResource(_ resource: Resource) -> ResourceTableViewController {
        let storyboard = UIStoryboard(name: "TabsStoryboard", bundle: nil)

        let viewController =
            storyboard.instantiateViewController(withIdentifier: "resourceVC") as! ResourceTableViewController
        viewController.resource = resource
        return viewController
    }
}
