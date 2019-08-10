//
//  TestActivityViewController.swift
//  
//
//  Created by Alvin on 2019/7/8.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit
import RSLoadingView

class TestActivityViewController: UIViewController {
    let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
    @IBOutlet weak var testView: UIView!
    @IBAction func test(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.shouldTapToDismiss = true
        loadingView.show(on: view)
        loadingView.sizeFactor = 2.0
   
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }

}
