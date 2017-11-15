//
//  UIViewController+KMExtension.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/15.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import UIKit
public extension Kunmin where Base : UIViewController {
    func addLeftBarButton(_ image : UIImage?, _ action : Selector, _ size : CGSize = CGSize(width: 44, height: 44)) {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        button.setImage(image, for: .normal)
        button.addTarget(self.base, action: action, for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.base.navigationItem.leftBarButtonItem = barButton
    }
    func addLeftBarButton(_ text:String, _ action : Selector, _ textColor : UIColor = UIColor.white, font : UIFont = UIFont.systemFont(ofSize: 15)) {
        let button = UIButton(type: .custom)
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.addTarget(self.base, action: action, for: .touchUpInside)
        button.titleLabel?.font = font
        button.sizeToFit()
        let barButton = UIBarButtonItem(customView: button)
        self.base.navigationItem.leftBarButtonItem = barButton
    }
}
