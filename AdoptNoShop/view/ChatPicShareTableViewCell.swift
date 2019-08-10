//
//  ChatPicShareTableViewCell.swift
//  
//
//  Created by Alvin on 2019/7/31.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit

class ChatPicShareTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var sharePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEnterTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.borderWidth = 1
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.layer.borderColor = UIColor.white.cgColor
        sharePic.clipsToBounds = true
        sharePic.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initdata(){
        userImage.image = UIImage(named: "noimage")
        sharePic.image = UIImage(named: "waiting")
    }

}
