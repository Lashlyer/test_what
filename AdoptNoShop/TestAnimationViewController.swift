//
//  TestAnimationViewController.swift
//  
//
//  Created by Alvin on 2019/7/6.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit

class TestAnimationViewController: UIViewController {

    @IBOutlet weak var infomationGreen: NSLayoutConstraint!
    @IBOutlet weak var infomationLabel: NSLayoutConstraint!
    @IBOutlet weak var alvinLabel: NSLayoutConstraint!
    @IBOutlet weak var lanlanLabel: NSLayoutConstraint!
    @IBOutlet weak var testLabelAnimation: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        testLabelAnimation.constant -= view.bounds.width
        lanlanLabel.constant -= view.bounds.width
        alvinLabel.constant -= view.bounds.width
        infomationLabel.constant -= view.bounds.width
        infomationGreen.constant -= view.bounds.width
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.lanlanLabel.constant += self.view.bounds.width
            self.testLabelAnimation.constant += self.view.bounds.width
            self.infomationLabel.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alvinLabel.constant += self.view.bounds.width
            self.infomationGreen.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

}
