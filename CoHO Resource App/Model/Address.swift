//
//  Address.swift
//  CoHO Resource App
//
//  Created by Jasper on 10/8/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit
import CoreLocation

class Address: NSObject, NSCoding {
	var id: Int
	var desc: String
	var street1: String
	var street2: String
	var city: String
	var state: String
	var zip: String
	
	func encode(with coder: NSCoder) {
		coder.encode(self.id, forKey: "id")
		coder.encode(self.desc, forKey: "desc")
		coder.encode(self.street1, forKey: "street1")
		coder.encode(self.street2, forKey: "street2")
		coder.encode(self.city, forKey: "city")
		coder.encode(self.state, forKey: "state")
		coder.encode(self.zip, forKey: "zip")
	}
	
	required convenience init?(coder: NSCoder) {
		guard let desc = coder.decodeObject(forKey: "desc") as? String,
			let street1 = coder.decodeObject(forKey: "street1") as? String,
			let street2 = coder.decodeObject(forKey: "street2") as? String,
			let city = coder.decodeObject(forKey: "city") as? String,
			let state = coder.decodeObject(forKey: "state") as? String,
			let zip = coder.decodeObject(forKey: "zip") as? String
		else { return nil }
		
		let id = coder.decodeInteger(forKey: "id")
		
		self.init(
			id: id,
			desc: desc,
			street1: street1,
			street2: street2,
			city: city,
			state: state,
			zip: zip)
	}
	
	init (id: Int, desc: String, street1: String, street2: String, city: String, state: String, zip: String) {
		self.id = id
		self.desc = desc
		self.street1 = street1
		self.street2 = street2
		self.city = city
		self.state = state
		self.zip = zip
	}
	
	init? (json: [String:Any]) {
		guard let id = json["id"] as? Int,
            let desc = json["desc"] as? String,
			let street1 = json["street1"] as? String,
            let street2 = json["street2"] as? String,
			let city = json["city"] as? String,
            let state = json["state"] as? String,
			let zip = json["zip"] as? String
			else {
				return nil
		}
		
		self.id = id
		self.desc = desc
		self.street1 = street1
		self.street2 = street2
		self.city = city
		self.state = state
		self.zip = zip

	}
    
    func get2DCoordinates(locationCompletionHandler: @escaping (CLLocation?) -> Void) {
        let geoCoder = CLGeocoder()
        let address = "\(street1), \(city), \(state) \(zip)"
        geoCoder.geocodeAddressString(address, completionHandler: {(placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    locationCompletionHandler(nil)
                    return
            }
            
            // Use your location
            locationCompletionHandler(location)
            
        })
    }
}


