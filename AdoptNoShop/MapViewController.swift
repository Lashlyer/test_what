//
//  MapViewController.swift
//  
//
//  Created by Alvin on 2019/5/29.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {
    var addresDetail:String?
    var addresTitle:String?
    var reallocation : CLLocationCoordinate2D!
    
    @IBOutlet weak var googleMapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.brown
        googleMapView.delegate = self
        guard let newAddress = addresDetail else { return }
        guard let newTitle = addresTitle else { return }
        getCoordinate(newAddress) { (location) in
            guard let location = location else { return }
            let xScale:CLLocationDegrees = 0.01
            let yScale:CLLocationDegrees = 0.01
            let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: xScale, longitudeDelta: yScale)
            let regoin:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
            let camera = GMSCameraPosition.camera(withTarget: location, zoom: 17.0)
            self.googleMapView.camera = camera
            
            
            let marker = GMSMarker()
            marker.position = location
            marker.map = self.googleMapView
            marker.title = newTitle
            self.reallocation = location
            self.navigationItem.title = "地理位置"
            
            
        }
    }
    
    
    
    func getCoordinate(_ address:String, completion: @escaping (CLLocationCoordinate2D?) -> ()) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard error == nil else {
                print("error: \(error)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        if let go = self.storyboard?.instantiateViewController(withIdentifier: "PaNoViewController") as? PaNoViewController {
            
            go.location = reallocation
            
            self.navigationController?.pushViewController(go, animated: true)
        }
    }
   
}
