import UIKit

let url = URL(string: "https://cohoresourcebook.org/api/resource.php")
URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
	
	guard let data = data, error == nil else { return }
	
	do {
		let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
		if let categories = json["resources"] as? [Any] {
				print(categories[0])
		}
	} catch let error as NSError {
		print(error)
	}
}).resume()
