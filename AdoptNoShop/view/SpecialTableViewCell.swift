//
//  SpecialTableViewCell.swift
//  
//
//  Created by Alvin on 2019/5/27.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit
import FirebaseDatabase
class SpecialTableViewCell: UITableViewCell {
    
    
    let reference : DatabaseReference = Database.database().reference()
    var userLoveOn = false
    var address : String?
    var sex : String?
    var foundPlace : String?
    var dogNumber : String?
    var dogBody : String?
    var dogSick : String?
    var dogEgg : String?
    var house : String?
    var housePhone : String?
    var picture : String?
    var opneTime : String?
    var updateTime : String?
    var dogAge : String?
    
    

    @IBOutlet weak var loveImage: UIImageView!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myHouse: UILabel!
    
   
    @IBOutlet weak var myAge: UILabel!
    @IBOutlet weak var myHospital: UILabel!
    @IBOutlet weak var mySexImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        myImageView.clipsToBounds = true
        myImageView.layer.cornerRadius = 30
   
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func initdata(){
        myImageView.image = UIImage(named: "noimage")
        myHouse.text = ""
        mySexImage.image = UIImage(named: "images")
        loveImage.isHidden = true
    }
    
    override var frame: CGRect{
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.origin.x += 15
            frame.size.width -= 2 * 15
            super.frame = frame
        }
    }
    
}
