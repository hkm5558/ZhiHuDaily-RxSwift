//
//  KMConst.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/2.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import UIKit

let KScreenW : CGFloat = UIScreen.main.bounds.width
let KScreenH : CGFloat = UIScreen.main.bounds.height

let KNavHeight : CGFloat = UIScreen.main.bounds.height == 812 ? 88 : 64

let KStatusBarFrame = UIApplication.shared.statusBarFrame

let KStatusBarHeight = UIApplication.shared.statusBarFrame.height


struct Font {
    static func size(size : CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize:size)
    }
    static func bold(size : CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize:size)
    }
}

struct Color {
    static let menuBackground : UIColor = #colorLiteral(red: 0.137254902, green: 0.1647058824, blue: 0.1882352941, alpha: 1)
    static let menuSelectBackground : UIColor = #colorLiteral(red: 0.1058823529, green: 0.137254902, blue: 0.1607843137, alpha: 1)
    static let menuNormalText : UIColor = #colorLiteral(red: 0.5803921569, green: 0.6, blue: 0.6156862745, alpha: 1)
    static let menuSelectText : UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    static let themeBlue : UIColor = #colorLiteral(red: 0.2470588235, green: 0.5568627451, blue: 0.8156862745, alpha: 1)
}

struct Config {
    static let homeRowHeight : CGFloat = 90.0
    static let homeSectionHeight : CGFloat  = 38.0
    static let topStoryViewHeight : CGFloat  = 200.0
    static let pullToRefreshHeight : CGFloat = 64.0
    static let minOffsetY : CGFloat = -150
}

