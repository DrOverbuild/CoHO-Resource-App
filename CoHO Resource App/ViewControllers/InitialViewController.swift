//
//  InitialViewController.swift
//  CoHO Resource App
//
//  Created by Jasper on 10/9/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit

class InitialViewController: UITabBarController {
	
	var loadingAlert: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingAlert = UIAlertController(title: nil, message: "Loading data...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        loadingAlert.view.addSubview(loadingIndicator)
		
		
			//			bar.barTintColor = UIColor(displayP3Red: 30/255, green: 50/255, blue: 49/255, alpha: 1.0)
//		bar.tintColor = UIColor(displayP3Red: 244, green: 231, blue: 195, alpha: 1)
		
        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
//        self.navigationBar.isTranslucent = true
	}
    
	override func viewDidAppear(_ animated: Bool) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            print("we found the delegeate")
            if delegate.loadingData {
                present(self.loadingAlert, animated: true, completion: nil)
            }
        }
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
