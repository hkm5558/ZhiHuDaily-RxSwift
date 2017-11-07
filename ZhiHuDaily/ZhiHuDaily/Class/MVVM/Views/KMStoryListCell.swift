//
//  KMStoryListCell.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/6.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit
class KMStoryListCell: UITableViewCell {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var morePicView: UIImageView!
    @IBOutlet var titleRight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindStoryModel(with model : Story) {
        titleLbl.text = model.title
        morePicView.isHidden = !model.multipic
        imgView.isHidden = (model.images == nil)
        titleRight.constant = (model.images == nil) ? 15 : 105
        if model.images != nil {
            imgView?.kf.setImage(with: URL.init(string: (model.images?.first!)!), placeholder: R.image.field_Mask_Bg())
        }
    }
}
