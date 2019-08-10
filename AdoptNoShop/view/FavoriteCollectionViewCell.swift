//
//  FavoriteCollectionViewCell.swift
//  
//
//  Created by Alvin on 2019/6/17.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dogsImage: UIImageView!
    
    
    
    func initdata(){
        dogsImage.image = UIImage(named: "noimage")
      
    }
}
