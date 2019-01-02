//
//  API.swift
//  CoHO Resource App
//
//  Created by Jasper on 10/16/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class API {
	/// Returns all categories from server
	func loadAllCategories(fromDict dict: [String:Any]?) -> [Category] {
		var categories = [Category]()

		if let json = dict?["categories"] as? [Any]{
			for categoryJSON in json {
				guard let categoryDict = categoryJSON as? [String:Any] else {continue}
				guard let category = Category(json: categoryDict) else {continue}
				categories.append(category)
			}
		}

		return categories
	}

	func loadAllCounties(fromDict dict: [String:Any]?) -> [County] {
		var counties = [County]()
		
		if let json = dict?["counties"] as? [Any]{
			for countyJSON in json {
				guard let countyDict = countyJSON as? [String:Any] else {continue}
				guard let county = County(json: countyDict) else {continue}
				counties.append(county)
			}
		}
		
		return counties
	}
	
	/// Returns all resources from server
	func loadAllResources(fromDict dict: [String:Any]?) -> [Resource] {
		var resources = [Resource]()
		
		if let json = dict?["resources"] as? [Any]{
			for resourceJSON in json {
				guard let resourceDict = resourceJSON as? [String:Any] else {continue}
				guard let resource = Resource(json: resourceDict) else {continue}
				resources.append(resource)
			}
		}
		
		return resources
	}
	
	func fetchJSON(url: String, completion: @escaping ([String:Any]?)->()) {
		var dictionary: [String:Any]?
		
		let url = URL(string: "https://cohoresourcebook.org/api/" + url)
		URLSession.shared.dataTask(with:url!) {(data, response, error) in
			guard let data = data, error == nil else {
				// offline
				return completion(nil)
			}
			
			print(data)
			
			do {
				dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
				return completion(dictionary)
			} catch let error as NSError {
				print("Error fetching data")
				print(error)
				return completion(nil)
			}
			
		}.resume()
	}
	
	func loadDataFromServer(delegate: AppDelegate) {
		// TODO: Load cohoData from NSKeyedArchiver if fetchJSON fails
		
		fetchJSON(url: "fulldatabase.php", completion: {dictOp in
			if let dict = dictOp {
				let categories = self.loadAllCategories(fromDict: dict)
				let resources = self.loadAllResources(fromDict: dict)
				let counties = self.loadAllCounties(fromDict: dict)
				delegate.cohoData = CohoData(categories: categories, resources: resources, counties: counties)
				
				DispatchQueue.main.async {
					if let cohodata = delegate.cohoData {
						CohoData.saveData(data: cohodata)
					}
				}
				self.closeLoadWindow(delegate: delegate)
			} else {
				if let data = CohoData.loadData() {
					delegate.cohoData = data
					self.closeLoadWindow(delegate: delegate)
				} else {
					delegate.cohoData = CohoData(categories: [], resources: [], counties: [])
					self.closeLoadWindow(delegate: delegate, completion: {self.sendOfflineAlert(delegate: delegate)})
				}
			}
		})
	}
	
	func closeLoadWindow(delegate: AppDelegate, completion: (() -> Void)? = nil) {
		DispatchQueue.main.async {
			if let viewController = delegate.window?.rootViewController as? InitialViewController {
				viewController.dismiss(animated: true, completion: completion)
                
                // sometimes downloading data is too slow and the categories
                // view controller loads empty data set, so we need to reload
                for vc in viewController.viewControllers! {
                    if let categoriesView = (vc as! UINavigationController).topViewController as? CategoriesTableViewController {
                        categoriesView.categories = delegate.cohoData?.categories
                        categoriesView.tableView.reloadData()
                    } else if let countiesView = (vc as! UINavigationController).topViewController as? CountiesTableViewController {
                        countiesView.counties = delegate.cohoData?.counties
                        countiesView.tableView.reloadData()
                    }
                }
			}
		}
	}
	
	func sendOfflineAlert(delegate: AppDelegate) {
		DispatchQueue.main.async {
			if let viewController = delegate.window?.rootViewController as? InitialViewController {
				let alert = UIAlertController(title: "Offline", message: "You are offline. An Internet connection is needed to load the data for the first time.", preferredStyle: .alert)
				
				alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action) in
						alert.dismiss(animated: true, completion: nil)
					}))
				
				viewController.present(alert, animated: true, completion: nil)
			}
		}
	}
}
