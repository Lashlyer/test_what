//
//  PaNoViewController.swift
//  
//
//  Created by Alvin on 2019/6/27.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit
import GoogleMaps

class PaNoViewController: UIViewController {
    
    var location : CLLocationCoordinate2D!
    
    //街景服務
    @IBOutlet weak var paNoView: GMSPanoramaView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "街景服務"
        GMSPanoramaService().requestPanoramaNearCoordinate(location) { (pano, error) in
            
            if error != nil {
                
                print(error?.localizedDescription)
            } else {
                
                self.paNoView.panorama = pano
            }
        }
    }

}
