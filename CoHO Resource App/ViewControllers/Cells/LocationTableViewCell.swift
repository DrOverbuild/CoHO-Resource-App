//
//  LocationTableViewCell.swift
//  CoHO Resource App
//
//  Created by Jasper on 11/23/18.
//  Copyright © 2018 Jasper. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var street1: UILabel!
    @IBOutlet weak var street2: UILabel!
    @IBOutlet weak var city: UILabel!
    
    
    var mapCenter: CLLocationCoordinate2D {
        set {
            let region = MKCoordinateRegion(center: newValue, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.region = region
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = newValue
            mapView.addAnnotation(annotation)
            
//            let tap = UIGestureRecognizer(target: self, action: #selector(LocationTableViewCell.onTap))
//            mapView.addGestureRecognizer(tap)
//            mapView.isUserInteractionEnabled = true
        }
        
        get {
            return mapView.centerCoordinate
        }
    }
    
    
    
    @objc func onTap(viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let copyAction = UIAlertAction(title: "Copy", style: .default, handler: {(action) in
            var address = "\(self.street1.text!), \(self.street2.text!)"
            if !self.city.text!.isEmpty {
                address = "\(address), \(self.city.text!)"
            }
            
            UIPasteboard.general.string = address
            
            alert.dismiss(animated: true, completion: nil)
        })
        
        let openAction = UIAlertAction(title: "Open in Maps", style: .default, handler: {(action) in
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: self.mapCenter))
            mapItem.name = self.titleLabel.text
            mapItem.openInMaps(launchOptions: nil)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(copyAction)
        alert.addAction(openAction)
        alert.addAction(cancel)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
