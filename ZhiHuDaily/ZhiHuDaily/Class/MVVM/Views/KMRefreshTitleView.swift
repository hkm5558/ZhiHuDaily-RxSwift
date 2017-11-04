//
//  KMRefreshTitleView.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/4.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit
import Then
class KMRefreshTitleView: UIView {

    fileprivate var label : UILabel?
    
    var text : String?
    
   
    init(with text : String){
        super.init(frame: .zero)
        self.text = text
        self.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label?.frame = bounds
    }
    
}

extension KMRefreshTitleView {
    func setup() {
        setupLabel()
    }
    
    func setupLabel() {
        label = UILabel().then({
            $0.textAlignment = .center
            $0.font = Font.bold(size: 15)
            $0.textColor = .white
            $0.text = self.text
        })
        addSubview(label!)
    }
    
}
