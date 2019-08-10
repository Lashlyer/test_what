//
//  UserTableViewCell.swift
//
//
//  Created by Alvin on 2019/6/21.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {


    @IBOutlet weak var userEnterTime: UILabel!
    @IBOutlet weak var userMessage: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        userMessage.clipsToBounds = true
        userMessage.layer.cornerRadius = 10
        userImage.layer.borderWidth = 1
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.layer.borderColor = UIColor.white.cgColor
        userMessage.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initdata(){
        userImage.image = UIImage(named: "noimage")
    }
    
}
