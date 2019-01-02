//
//  ContactTableViewCell.swift
//  CoHO Resource App
//
//  Created by Jasper on 11/23/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit
import MessageUI

class ContactTableViewCell: UITableViewCell, MFMailComposeViewControllerDelegate {
	
	var contact: Contact! {
		didSet {
			title.text = contact.name
			value.text = contact.value
			
			switch contact.type {
			case .email:
				if contact.name.isEmpty {
					title.text = "Email"
				}
				icon.image = UIImage(named: "email")
			case .phone:
				if contact.name.isEmpty {
					title.text = "Phone"
				}
				icon.image = UIImage(named: "phonesmall")
			case .website:
				if contact.name.isEmpty {
					title.text = "Website"
				}
				icon.image = UIImage(named: "website")
			default:
				if contact.name.isEmpty {
					title.text = "Fax"
				}
				icon.image = UIImage(named: "fax")
				// fax/unknown
			}
		}
	}
	
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var value: UILabel!
	@IBOutlet weak var icon: UIImageView!
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	func onTap(viewController: UIViewController) {
		var actionTitle = ""
		var handler: ((UIAlertAction) -> Void)!
		
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		switch contact.type {
		case .phone:
			actionTitle = "Call"
			
			handler = {(action) in
				alert.dismiss(animated: true, completion: nil)
				self.callNumber()
			}
			
		case .website:
			actionTitle = "Visit Website"
			
			handler = {(action) in
				alert.dismiss(animated: true, completion: nil)
				self.visitSite()
			}
		case .email:
			if MFMailComposeViewController.canSendMail() {
				actionTitle = "Send Email"
				
				handler = {(action) in
					alert.dismiss(animated: true, completion: nil)
					self.sendEmail(viewController: viewController)
				}
			} else {
				actionTitle = ""
			}
			
		default:
			actionTitle = ""
		}
		
		if !actionTitle.isEmpty {
			let callAction = UIAlertAction(title: actionTitle, style: .default, handler: handler)
			alert.addAction(callAction)
		}
		
		let copyAction = UIAlertAction(title: "Copy", style: .default, handler: {(action) in
			UIPasteboard.general.string = self.contact.value
			alert.dismiss(animated: true, completion: nil)
		})
		alert.addAction(copyAction)
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
			alert.dismiss(animated: true, completion: nil)
		})
		alert.addAction(cancel)
		
		viewController.present(alert, animated: true, completion: nil)
	}
	
	func callNumber() {
		if let url = URL(string: "tel://\(contact.value)"), UIApplication.shared.canOpenURL(url) {
			if #available(iOS 10, *) {
				UIApplication.shared.open(url)
			} else {
				UIApplication.shared.openURL(url)
			}
		}
	}
	
	func visitSite() {
		var urlStr = contact.value
		
		if (!urlStr.starts(with: "http")) {
			urlStr = "http://\(urlStr)"
		}
		
		if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
			if #available(iOS 10, *) {
				UIApplication.shared.open(url)
			} else {
				UIApplication.shared.openURL(url)
			}
		}
	}
	
	func sendEmail(viewController: UIViewController) {
		if MFMailComposeViewController.canSendMail() {
			let mail = MFMailComposeViewController()
			mail.mailComposeDelegate = self
			mail.setToRecipients([contact.value])
			mail.setMessageBody("", isHTML: true)
			
			viewController.present(mail, animated: true)
		} else {
			// show failure alert
		}
	}
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true)
	}
}
