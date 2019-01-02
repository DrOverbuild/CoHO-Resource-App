//
//  CohoData.swift
//  CoHO Resource App
//
//  Created by Jasper on 10/21/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class CohoData: NSObject, NSCoding {
	var categories: [Category]
	var counties: [County]
	var resources: [Resource]
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(categories, forKey: "categories")
		aCoder.encode(resources, forKey: "resources")
		aCoder.encode(counties, forKey: "counties")
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		guard let categories = aDecoder.decodeObject(forKey: "categories") as? [Category],
			let resources = aDecoder.decodeObject(forKey: "resources") as? [Resource],
			let counties = aDecoder.decodeObject(forKey: "counties") as? [County]
		else { return nil }
		
		self.init(categories: categories, resources: resources, counties: counties)
	}
	
	
	init(categories: [Category], resources: [Resource], counties: [County]) {
		self.categories = categories
		self.resources = resources
		self.counties = counties
		for resource in self.resources {
			resource.loadResCategories(fromAllCategories: self.categories)
		}
		
		for category in self.categories {
			category.loadResources(fromAllResources: self.resources)
		}
		
		for county in self.counties {
			county.loadResources(fromAllResources: self.resources)
		}
	}
	
	static var filePath: String {
		let manager = FileManager.default
		let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
		return (url!.appendingPathComponent("cohodata").path)
	}

	class func saveData(data: CohoData) {
		do {
			let archive = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
			let url = URL(fileURLWithPath: filePath)
			try archive.write(to: url)
		} catch {
			print("Save data error.")
		}
	}
	
	class func loadData() -> CohoData? {
		do {
			let url = URL(fileURLWithPath: filePath)
			let data = try Data(contentsOf: url)
			if let cohodata = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? CohoData {
				return cohodata
			} else {
				print("Data decoding error")
			}
		
		} catch {
			print("Load data error")
		}
		
		return nil
	}
}
