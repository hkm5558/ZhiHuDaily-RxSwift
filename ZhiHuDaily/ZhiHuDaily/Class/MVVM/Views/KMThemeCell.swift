//
//  KMThemeCell.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/3.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit

class KMThemeCell: UITableViewCell  {

    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var homeIcon: UIImageView!
    
    @IBOutlet var rightIcon: UIImageView!
    
    @IBOutlet var nameLeft: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if selected {
            nameLabel.font = Font.bold(size: 15)
            nameLabel.textColor = .white
            contentView.backgroundColor = UIColor.init(hexString: "1D2328")
            homeIcon.image = R.image.menu_Icon_Home_Highlight()
        }else {
            nameLabel.font = Font.size(size: 15)
            nameLabel.textColor = UIColor.init(hexString: "95999D")
            contentView.backgroundColor = UIColor.clear
            homeIcon.image = R.image.menu_Icon_Home()
        }
        
    }

}
