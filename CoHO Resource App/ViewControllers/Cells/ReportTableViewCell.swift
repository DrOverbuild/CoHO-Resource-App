//
//  ReportTableViewCell.swift
//  CoHO Resource App
//
//  Created by Jasper on 2/2/19.
//  Copyright © 2019 Jasper. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func onTap(viewController: ResourceTableViewController) {
		let handlr = {(action: UIAlertAction) in self.actionTapped(action, viewController)}
		
		let alert = UIAlertController(title: "", message: "Help us keep this guide up to date by letitng us know what's wrong with this resource.", preferredStyle: .actionSheet)
		let inaccurateAction = UIAlertAction(title: "Inaccurate details", style: .default, handler: handlr)
		let confusingAction = UIAlertAction(title: "Confusing to read", style: .default, handler: handlr)
		let formattedAction = UIAlertAction(title: "Formatted incorrectly", style: .default, handler: handlr)

		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		alert.addAction(inaccurateAction)
		alert.addAction(confusingAction)
		alert.addAction(formattedAction)
		alert.addAction(cancel)
		
		viewController.present(alert, animated: true, completion: nil)
	}
	
	func actionTapped(_ action: UIAlertAction, _ viewController: ResourceTableViewController) {
		let alert  = UIAlertController(title: action.title!, message: "Please provide us with additional details", preferredStyle: .alert)
		
		alert.addTextField(configurationHandler: nil)
		
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let submit = UIAlertAction(title: "Submit", style: .default, handler: {(localAction) in self.submit(localAction, action.title!, alert.textFields![0].text!, viewController)})
		
		alert.addAction(cancel)
		alert.addAction(submit)
		
		viewController.present(alert, animated: true, completion: nil)
	}
	
	func submit(_ action: UIAlertAction, _ feedbackType: String, _ desc: String, _ viewController: ResourceTableViewController) {
		// TODO implement feedback details (need api implementation in server first)
		let resourcee = viewController.resource.name
		
		(UIApplication.shared.delegate as! AppDelegate).api.sendReport(resource: resourcee, feedbackType: feedbackType, comments: desc)
		
		let alert = UIAlertController(title: "Report Sent", message: "Thank you for your feedback. We will try to update as soon as possible.", preferredStyle: .alert)
		let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
		alert.addAction(ok)
		viewController.present(alert, animated: true, completion: nil)
		
	}
}
