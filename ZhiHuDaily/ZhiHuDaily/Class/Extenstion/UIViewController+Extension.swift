//
//  UIViewController+Extension.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/4.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /// 避免自动下移64
    func avoidAutomaticDown64() {
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .all
        automaticallyAdjustsScrollViewInsets = false
    }
    func setNavigationBackgroundColor(with color : UIColor) {
        navigationController?.navigationBar.barTintColor = color
    }
}
