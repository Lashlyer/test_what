//
//  CollectTableViewCell.swift
//  
//
//  Created by Alvin on 2019/6/3.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit

class CollectTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate{
    weak var delegate: AllDogTableViewController?
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var choseLabel: UILabel!
    
    @IBOutlet weak var labelBottomConstraint2: NSLayoutConstraint!
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTableViewCell: UILabel!
    @IBOutlet weak var collectViewBottomConstrain: NSLayoutConstraint!
    let taiwan = ["全部","基隆市","新北市","台北市","桃園市","新竹縣","新竹市","苗栗縣","台中市","彰化縣","南投縣","雲林縣","嘉義縣","嘉義市","台南市","高雄市","屏東縣","台東縣","花蓮縣","宜蘭縣","澎湖縣","連江縣","金門縣"]
    let animal = ["全部","汪星人","喵星人"]
    let area = [0,4,3,2,6,7,8,9,10,11,12,13,14,15,16,17,18,20,19,5,21,23,22]
    let animalKindNumber = [0,1,2]
    var tmpArray: [String] = []
    var save : String = ""
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tmpArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("為什麼:\(indexPath)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCollectionViewCell
        
        
        if tmpArray.count == animal.count {
            cell.searchImage.image = UIImage(named: "buttonyellow")
        }else {
            cell.searchImage.image = UIImage(named: "button")
        }
        cell.searchLabel.text = tmpArray[indexPath.row]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let areasearch = collectionView.cellForItem(at: indexPath) as? MyCollectionViewCell else { return }
       
        
        if tmpArray.count == taiwan.count {
            
            
            delegate?.searchDogData(status: area[indexPath.item])
      
            choseLabel.text = taiwan[indexPath.item]
            delegate?.save = taiwan[indexPath.item]
            
            
        }else if tmpArray.count == animal.count{
            
            delegate?.searchKindData(kind: animalKindNumber[indexPath.item])

            choseLabel.text = animal[indexPath.item]
            delegate?.saveKind = animal[indexPath.item]

        }
        
       
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

    func setupCell(indexPath: IndexPath) {
        if indexPath.row == 0 {
            tmpArray = taiwan
        }else if indexPath.row == 1 {
            tmpArray = animal
        }
    }
   
    
}
