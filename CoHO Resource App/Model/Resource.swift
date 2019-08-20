//
//  Resource.swift
//  CoHO Resource App
//
//  Created by Jasper on 10/8/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class Resource: NSObject, NSCoding {
	var id: Int
	var name: String
	var tags: String = ""
	
	var categoryIDs = [Int]()
	var countyIDs = [Int]()
	var categories = [Category]()
	var counties = [County]()
	var locations = [Address]()
	var contact = [Contact]()
	
	var desc: String = ""
	var services: String = ""
	var documentation: String = ""
	var hours: String = ""
	
	func encode(with coder: NSCoder) {
		coder.encode(self.id, forKey: "id")
		coder.encode(self.tags, forKey: "tags")
		coder.encode(self.name, forKey: "name")
		coder.encode(self.categoryIDs, forKey: "catIDs")
		coder.encode(self.countyIDs, forKey: "countyIDs")
		coder.encode(self.locations, forKey: "locations")
		coder.encode(self.contact, forKey: "contact")
		coder.encode(self.desc, forKey: "desc")
		coder.encode(self.services, forKey: "services")
		coder.encode(self.documentation, forKey: "documentation")
		coder.encode(self.hours, forKey: "hours")
	}
	
	required init?(coder aDecoder: NSCoder) {
		guard let name = aDecoder.decodeObject(forKey: "name") as? String,
			let tags = aDecoder.decodeObject(forKey: "tags") as? String,
			let catIDs = aDecoder.decodeObject(forKey: "catIDs") as? [Int],
			let countyIDs = aDecoder.decodeObject(forKey: "countyIDs") as? [Int],
			let locations = aDecoder.decodeObject(forKey: "locations") as? [Address],
			let contact = aDecoder.decodeObject(forKey: "contact") as? [Contact],
			let desc = aDecoder.decodeObject(forKey: "desc") as? String,
			let services = aDecoder.decodeObject(forKey: "services") as? String,
			let hours = aDecoder.decodeObject(forKey: "hours") as? String,
			let documentation = aDecoder.decodeObject(forKey: "documentation") as? String
		else {
				return nil
		}
		
		let id = aDecoder.decodeInteger(forKey: "id")
		
		self.name = name
		self.id = id
		self.tags = tags
		self.categoryIDs = catIDs
		self.countyIDs = countyIDs
		self.locations = locations
		self.contact = contact
		self.desc = desc
		self.services = services
		self.hours = hours
		self.documentation = documentation
	}
	
	init(id: Int, name: String) {
		self.id = id
		self.name = name
	}
	
	init?(json: [String: Any]) {
		guard let id = json["id"] as? Int, let name = json["name"] as? String else {
			return nil
		}
		
		self.id = id
		self.name = name
		
		if let tags = json["tags"] as? String {
			self.tags = tags
		}
		
		if let desc = json["description"] as? String {
			self.desc = desc
		}
		
		if let categoryIDs = json["categories"] as? [Int] {
			self.categoryIDs = categoryIDs
		}
		
		if let countyIDs = json["counties"] as? [Int] {
			self.countyIDs = countyIDs
		}
		
		if let locationsJson = json["locations"] as? [Any] {
			for locationArr in locationsJson {
				if let locationJSON = locationArr as? [String:Any] {
					if let location = Address(json: locationJSON) {
						self.locations.append(location)
					}
				}
			}
		}
		
		if let contactsJSON = json["contact"] as? [Any] {
			for contactArr in contactsJSON {
				if let contactJSON = contactArr as? [String:Any] {
					if let contact = Contact(json: contactJSON) {
						self.contact.append(contact)
					}
				}
			}
		}
		
		if let services = json["services"] as? String {
			self.services = services
		}
		
		if let documentation = json["documentation"] as? String {
			self.documentation = documentation
		}
		
		if let hours = json["hours"] as? String {
			self.hours = hours
		}
	}
	
	/// A resource object initialized from JSON will not have access to all the Categories to search for the IDs. This must be called after loading both categories and resources.
	func loadResCategories(fromAllCategories allCategories: [Category]) {
		for category in allCategories {
			if self.categoryIDs.contains(category.id) {
				self.categories.append(category)
			}
		}
	}
	
	/// A resource object initialized from JSON will not have access to all the counties to search for the IDs. This must be called after loading both categories and resources.
	func loadResCounties(fromAllCounties allCounties: [County]) {
		for county in allCounties {
			if self.countyIDs.contains(county.id) {
				self.counties.append(county)
			}
		}
	}
	
	/// this is probably not gonna work... given JSON will be of type [Any]
	class func resourcesFromJSON(json: [String: Any]) -> [Resource] {
		var resources = [Resource]()
		for (_, value) in json {
			if let resourceJson = value as? [String: Any] {
				if let resource = Resource(json: resourceJson) {
					resources.append(resource)
				}
			}
		}
		return resources
	}
    
    func dictRepresentation() -> [String: Any] {
        
//        var id: Int
//        var name: String
//        var tags: String = ""
//
//        var categoryIDs = [Int]()
//        var countyIDs = [Int]()
//        var categories = [Category]()
//        var counties = [County]()
//        var locations = [Address]()
//        var contact = [Contact]()
//
//        var desc: String = ""
//        var services: String = ""
//        var documentation: String = ""
//        var hours: String = ""
        
        var locationDicts = [[String: Any]]()
        for location in self.locations {
            locationDicts.append(location.dictRepresentation())
        }
        
        var contactDicts = [[String: Any]]()
        for contact in self.contact {
            contactDicts.append(contact.dictRepresentation())
        }
        
        return ["id" : id,
                "name" : name,
                "tags" : tags,
                "locations" : locationDicts,
                "contact" : contactDicts,
                "categories" : categoryIDs,
                "counties" : countyIDs,
                "description" : desc,
                "services" : services,
                "documentation" : documentation,
                "hours" : hours]
    }
}
