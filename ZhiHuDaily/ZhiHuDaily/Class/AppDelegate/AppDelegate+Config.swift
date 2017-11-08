//
//  AppDelegate+Config.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/2.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift
import SwiftyBeaver
import RTRootNavigationController
let log = SwiftyBeaver.self

extension AppDelegate {
    func config(WithOptions launchOptions : [UIApplicationLaunchOptionsKey: Any]?) {
        
        //设置Log
        setupLogger()
        
        adaptedIOS11()
        
        configTableView()
        
        initWindow()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    func initWindow() {
        
        SlideMenuOptions.leftViewWidth = 225
        SlideMenuOptions.contentViewDrag = true
//        SlideMenuOptions.simultaneousGestureRecognizers = false
        SlideMenuOptions.contentViewOpacity = 0.0
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.hideStatusBar = false
        SlideMenuOptions.leftBezelWidth = UIScreen.main.bounds.width/4.0
        
        
        let homeVC = R.storyboard.kmStoryboard.kmHomeViewController()
        
        let menuVC = R.storyboard.kmStoryboard.kmMenuViewController()

        let homeNav = UINavigationController(rootViewController: homeVC!)
        menuVC?.home = homeNav


        let slideMenuVC = SlideMenuController(mainViewController: homeNav, leftMenuViewController: menuVC!)
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = slideMenuVC
        window?.makeKeyAndVisible()
    }
}

fileprivate extension AppDelegate {
    
    //MARK: - 设置Log日志
    fileprivate func setupLogger() {
        // add log destinations. at least one is needed!
        let console = ConsoleDestination()  // log to Xcode Console
        console.minLevel = .debug // just log .info, .warning & .error
        log.addDestination(console)
    }
    
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
    
    func configTableView() {
        UITableView.appearance().separatorStyle = .none
//        UITableViewCell.appearance().selectionStyle = .none
    }
    
}
