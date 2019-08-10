//
//  InFoMationViewController.swift
//  
//
//  Created by Alvin on 2019/7/5.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit

class InFoMationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? InFoMationTableViewCell else {
        
            let cell = UITableViewCell()
            return cell
       
        }
        switch indexPath.row {
        case 0:
            cell.inFoMationLabel.text = "關於『 浪浪搜尋 』"
            cell.inFoMationImage.image = UIImage(named: "dog")
        case 1:
            cell.inFoMationLabel.text = "領養須知"
            cell.inFoMationImage.image = UIImage(named: "dog-food")
        case 2:
            cell.inFoMationLabel.text = "領養步驟"
            cell.inFoMationImage.image = UIImage(named: "cat-food")
        case 3:
            cell.inFoMationLabel.text = "評分鼓勵"
            cell.inFoMationImage.image = UIImage(named: "review")
        default:
            cell.inFoMationLabel.text = ""
        }
        
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            
        }
        
        switch indexPath.row {
        case 0:
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "what") {
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 2:
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DogGetViewController") {
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
    }

}
