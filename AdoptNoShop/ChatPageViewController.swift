//
//  ChatPageViewController.swift
//  
//
//  Created by Alvin on 2019/7/15.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit

class ChatPageViewController: UIViewController {
    var chat : ChatViewController!
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatPage" {
         chat = segue.destination as? ChatViewController
            
        }
    }
}
