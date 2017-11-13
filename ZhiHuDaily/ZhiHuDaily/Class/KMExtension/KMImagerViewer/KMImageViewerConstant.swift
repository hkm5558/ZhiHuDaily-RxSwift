//
//  KMImageViewerConstant.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/13.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation

struct KMImageViewerConstant {
    static let photoViewPadding: CGFloat = 10
    static let photoViewMaxScale: CGFloat = 3
    static let springAnimationDuration: TimeInterval = 0.3
    
    static let screenW: CGFloat = UIScreen.main.bounds.width
    static let screenH: CGFloat = UIScreen.main.bounds.height
    
    //MARK: - 延时执行
    static func delay(_ seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
}
