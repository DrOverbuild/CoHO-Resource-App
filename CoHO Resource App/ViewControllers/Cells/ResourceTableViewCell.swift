//
//  ResourceTableViewCell.swift
//  CoHO Resource App
//
//  Created by Jasper on 11/5/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class ResourceTableViewCell: UITableViewCell {

	@IBOutlet weak var label: UILabel!
    var resource: Resource!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
