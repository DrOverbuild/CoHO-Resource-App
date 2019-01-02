//
//  TitleTableViewCell.swift
//  CoHO Resource App
//
//  Created by Jasper on 11/23/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
