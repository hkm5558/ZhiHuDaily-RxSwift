//
//  AppDelegate+Config.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/2.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import UIKit


extension AppDelegate {
    func config(WithOptions launchOptions : [UIApplicationLaunchOptionsKey: Any]?) {
        adaptedIOS11()
        
        initWindow()
        
        
    }
    
    func initWindow() {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = R.storyboard.kmStoryboard.kmHomeViewController()
        window?.makeKeyAndVisible()
    }
}

fileprivate extension AppDelegate {
    //MARK: - 适配iOS 11
    func adaptedIOS11() {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
            UITableView.appearance().estimatedRowHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0
            UITableView.appearance().estimatedSectionHeaderHeight = 0
        } else {
            // Fallback on earlier versions
        }
    }
}
