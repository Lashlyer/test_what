//
//  SearchViewController.swift
//  
//
//  Created by Alvin on 2019/5/31.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController{

  
    weak var delegate: AllDogTableViewController?
    var save : String!
    var saveKind : String!

    @IBAction func backItem(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "篩選"
        
    }
    
    deinit {
        print("deinit")
    }
}





extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "CollectTableViewCell", for: indexPath) as? CollectTableViewCell else {
            let cell = UITableViewCell()
            return cell
        }
        if indexPath.row == 0 {
            cell.searchTableViewCell.text = "目前地區 ->"
            cell.choseLabel.text = save
        }else if indexPath.row == 1 {
            cell.searchTableViewCell.text = "目前種類 ->"
            cell.choseLabel.text = saveKind
        }
        cell.delegate = delegate
        cell.setupCell(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let areaCell = tableView.cellForRow(at: indexPath) as? CollectTableViewCell else {
            return
        }
        
        if areaCell.collectViewHeightConstraint.constant == 100 {
            
                areaCell.collectViewHeightConstraint.constant = 0
                tableView.beginUpdates()
                tableView.endUpdates()

        }else{
            
                areaCell.collectViewHeightConstraint.constant = 100
                tableView.beginUpdates()
                tableView.endUpdates()
        }
    }
 
}
