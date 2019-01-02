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
	
	var resources = [Resource]()
	
	init(name: String, itemDesc: String, id: Int) {
		self.name = name
		self.itemDesc = itemDesc
		self.id = id
	}
}
