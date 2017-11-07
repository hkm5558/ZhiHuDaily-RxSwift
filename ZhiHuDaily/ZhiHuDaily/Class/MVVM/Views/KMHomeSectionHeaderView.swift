//
//  KMHomeSectionHeaderView.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/7.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit

class KMHomeSectionHeaderView: UITableViewHeaderFooterView {

    
    var sectionTitle = "" {
        didSet { label.text = sectionTitle }
    }
    
    
    fileprivate var label : UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension KMHomeSectionHeaderView {
    func setup() {
        contentView.backgroundColor = Color.themeBlue
        label = UILabel().then({
            $0.textColor = .white
            $0.textAlignment = .center
            $0.font = Font.size(size: 15)
        })
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
}
