//
//  DogGetViewController.swift
//  
//
//  Created by Alvin on 2019/7/9.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit
import WebKit
class DogGetViewController: UIViewController {

    
    @IBOutlet weak var myWebViewGO: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "https://www.tcapo.gov.taipei/cp.aspx?n=191BFCF7B68FA59A") {
            
            let go = URLRequest(url: url)
            myWebViewGO.load(go)
        }
    }

}
