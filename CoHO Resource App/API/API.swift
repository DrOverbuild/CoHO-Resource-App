//
//  API.swift
//  CoHO Resource App
//
//  Created by Jasper on 10/16/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class API {
    let baseUrl = "https://cohoresource.app/api"
    
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
	
	func fetchJSON(urlStr: String, completion: @escaping ([String:Any]?)->()) {
		var dictionary: [String:Any]?
		
		// check last updated
		let currentDate = Date()
		
		if let lastUpdated = UserDefaults.standard.object(forKey: "lastUpdated") as? Date {
			if let updateFrequncy = UserDefaults.standard.string(forKey: "updateFrequency") {
				var interval: DateInterval!
				
				switch updateFrequncy {
				case "weekly":
					let weekFromLastUpdated = Calendar.current.date(byAdding: .day, value: 7, to: lastUpdated)!
					interval = DateInterval(start: lastUpdated, end: weekFromLastUpdated)
					
					if interval.contains(currentDate) {
						return completion(nil)
					}
					
					break
				case "monthly":
					let weekFromLastUpdated = Calendar.current.date(byAdding: .day, value: 30, to: lastUpdated)!
					interval = DateInterval(start: lastUpdated, end: weekFromLastUpdated)
										
					if interval.contains(currentDate) {
						return completion(nil)
					}
					
					break
				default:
					break
				}
			}
			
		}
        
		let url = URL(string: "\(baseUrl)/\(urlStr)")!
        
		URLSession.shared.dataTask(with:url) {(data, response, error) in
			guard let data = data, error == nil else {
				// offline
				return completion(nil)
			}
			
			print(data)
			
			do {
				dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
				// update last updated
				let currentDate = Date()
				UserDefaults.standard.set(currentDate, forKey: "lastUpdated")
				
				return completion(dictionary)
			} catch let error as NSError {
				return completion(nil)
			}
			
		}.resume()
	}
	
	func loadDataFromServer(delegate: AppDelegate) {
		fetchJSON(urlStr: "fulldatabase", completion: {dictOp in
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
        delegate.loadingData = false
		DispatchQueue.main.async {
			if let viewController = delegate.window?.rootViewController as? InitialViewController {
				// end refreshing
				if let initialVC = delegate.window?.rootViewController as? InitialViewController {
					for vc in initialVC.viewControllers! {
						if let categoriesView = (vc as! UINavigationController).topViewController as? CategoriesTableViewController {
							if let refreshControl = categoriesView.refreshControl {
								refreshControl.endRefreshing()
							}
						}
					}
				}
				
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
	
	func sendReport(resource: String, feedbackType: String, comments: String) {
		var request = URLRequest(url: URL(string: "\(baseUrl)/feedback")!)
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "POST"
		let parameters: [String: Any] = [
			"apikey": self.key,
			"secret": self.secret,
			"type": feedbackType,
			"resource": resource,
			"comments": comments
		]
		
		request.httpBody = parameters.percentEscaped().data(using: .utf8)
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			// maybe in a later update we'll want to let user know we
			// failed to send their report, but for now we don't care
			
//			guard let data = data,
//				let response = response as? HTTPURLResponse,
//				error == nil else {                                              // check for fundamental networking error
//					return
//			}
//
//			guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
//				return
//			}
			
//			let responseString = String(data: data, encoding: .utf8)
		}
		
		task.resume()
	}
}
