//
//  OrganizationalLevel.swift
//  CoHO Resource App
//
//  Created by Jasper on 10/30/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class OrganizationalLevel: NSObject {
	var name: String = ""
	var itemDesc: String?
	var id: Int
	var icon: String?
	
	var iconImage: UIImage? {
		get {
			if let icon = self.icon {
				if let range = icon.range(of: "/") {
					let imageString = icon[range.upperBound...]
					if let image = UIImage(named: String(imageString)) {
						return image
					}
				}
			}
			return nil
		}
	}
	
	var resources = [Resource]()
	
	init(name: String, itemDesc: String, id: Int) {
		self.name = name
		self.itemDesc = itemDesc
		self.id = id
	}
	
	init(name: String, itemDesc: String, id: Int, icon: String) {
		self.name = name
		self.itemDesc = itemDesc
		self.id = id
		self.icon = icon
	}
}
