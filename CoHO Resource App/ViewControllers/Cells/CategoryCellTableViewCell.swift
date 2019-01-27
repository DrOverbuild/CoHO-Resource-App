//
//  CategoryCellTableViewCell.swift
//  CoHO Resource App
//
//  Created by Jasper on 10/26/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class CategoryCellTableViewCell: UITableViewCell {

	
	@IBOutlet weak var catNameLabel: UILabel!
	@IBOutlet weak var itemsLabel: UILabel!
	@IBOutlet weak var iconView: UIImageView!
	
	// only used for search
	var resource: Resource!
	
	var level: OrganizationalLevel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func populateWithData(level: OrganizationalLevel) {
		self.level = level
		self.catNameLabel.text = level.name
		
		if let image = self.level.iconImage {
			self.iconView.image = image
		}
		
		let count = level.resources.count
		
		if count == 1 {
			self.itemsLabel.text = "1 item"
		} else {
			self.itemsLabel.text = "\(count) items"
		}
	}
}
