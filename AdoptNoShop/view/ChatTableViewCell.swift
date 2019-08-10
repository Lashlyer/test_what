//
//  ChatTableViewCell.swift
//  
//
//  Created by Alvin on 2019/6/21.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var userEnterTime: UILabel!
    @IBOutlet weak var userMessage: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var messageBackGround: UIView!
    @IBOutlet weak var UserImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        userMessage.clipsToBounds = true
        userMessage.layer.cornerRadius = 10
        
        UserImage.layer.borderWidth = 1
        UserImage.clipsToBounds = true
        UserImage.layer.cornerRadius = UserImage.frame.width / 2
        UserImage.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initdata(){
        UserImage.image = UIImage(named: "noimage")
    }
    

}
