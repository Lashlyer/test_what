//
//  InFoMationTableViewCell.swift
//  
//
//  Created by Alvin on 2019/7/5.
//  Copyright © 2019 Alvin. All rights reserved.
//

import UIKit

class InFoMationTableViewCell: UITableViewCell {

    @IBOutlet weak var inFoMationImage: UIImageView!
    @IBOutlet weak var inFoMationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
