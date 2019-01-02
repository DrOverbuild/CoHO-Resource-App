//
//  Category.swift
//  CoHO Resource App
//
//  Created by Jasper on 10/8/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class County: OrganizationalLevel, NSCoding {
	
	// MARK NSCoder
	func encode(with coder: NSCoder) {
		coder.encode(self.id, forKey: "id")
		coder.encode(self.itemDesc, forKey: "desc")
		coder.encode(self.name, forKey: "name")
	}
	
	required init?(coder aDecoder: NSCoder) {
		guard let name = aDecoder.decodeObject(forKey: "name") as? String,
			let desc = aDecoder.decodeObject(forKey: "desc") as? String
			else {
				print("Could not decode County object")
				return nil
		}
		
		let id = aDecoder.decodeInteger(forKey: "id")
		
		super.init(name: name, itemDesc: desc, id: id)
	}
	
	init?(json: [String: Any]) {
		guard let id = json["id"] as? Int,
			let name = json["name"] as? String,
			let desc = json["description"] as? String
		else {
			return nil
		}
		
		super.init(name: name, itemDesc: desc, id: id)
	}
	
	/// A county object loaded from JSON will not contain resources. Need to load resources after all resources are loaded.
	func loadResources(fromAllResources allResources: [Resource]) {
		for resource in allResources {
			if resource.countyIDs.contains(self.id) {
				self.resources.append(resource)
			}
		}
	}
}
