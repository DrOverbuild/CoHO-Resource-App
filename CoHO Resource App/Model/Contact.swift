//
//  Contact.swift
//  CoHO Resource App
//
//  Created by Jasper on 10/8/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class Contact: NSObject, NSCoding {
	var id: Int
	var type: ContactType
	var name: String
	var value: String
	
	func encode(with coder: NSCoder) {
		coder.encode(id, forKey: "id")
		coder.encode(type.rawValue, forKey: "type")
		coder.encode(name, forKey: "name")
		coder.encode(value, forKey: "value")
	}
	
	required init?(coder: NSCoder) {
		guard let type = ContactType(rawValue: coder.decodeInteger(forKey: "type")),
			let name = coder.decodeObject(forKey: "name") as? String,
			let value = coder.decodeObject(forKey: "value") as? String
		else {return nil}
		
		let id = coder.decodeInteger(forKey: "id")
		
		self.id = id
		self.type = type
		self.name = name
		self.value = value
	}
	
	init(id: Int, type: ContactType, name: String, value: String) {
		self.id = id
		self.type = type
		self.name = name
		self.value = value
		
	}
	
	init?(json: [String:Any]) {
		// validate json
		guard let id = json["id"] as? Int,
			let typeInt = json["type"] as? Int,
			let name = json["name"] as? String,
			let value = json["value"] as? String
		else {
			return nil
		}
		
		// vaildate typeInt
		guard typeInt >= 0 && typeInt <= 3 else {
			return nil
		}
		
		self.id = id
		self.type = ContactType(rawValue: typeInt)!
		self.name = name
		self.value = value
	}
}

enum ContactType: Int {
	case phone = 0, email = 1, website = 2, fax = 3
}
