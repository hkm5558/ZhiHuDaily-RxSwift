//
//  KMToast.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/3.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import CFNotify
import SwifterSwift
struct Toast {
    
    fileprivate init() {}
    
    
    static func show(with text:String) {
        let toastView = CFNotifyView.toastWith(text: text,
                                               theme: .info(.dark))
        toastView.backgroundColor = UIColor.init(hexString: "5e7c85")
        var toastViewConfig = CFNotify.Config()
        toastViewConfig.initPosition = .bottom(.center)
        toastViewConfig.appearPosition = .bottom
        toastViewConfig.thresholdDistance = 30
        toastViewConfig.hideTime = .custom(seconds: 2)
        toastViewConfig.angularResistance = 1
        
        CFNotify.present(config: toastViewConfig, view: toastView)
    }
    
    static func success(with text:String) {
        let toastView = CFNotifyView.toastWith(text: text,
                                               theme: .success(.dark))
        toastView.backgroundColor = UIColor.init(hexString: "009ad6")
        var toastViewConfig = CFNotify.Config()
        toastViewConfig.initPosition = .bottom(.center)
        toastViewConfig.appearPosition = .bottom
        toastViewConfig.thresholdDistance = 30
        toastViewConfig.hideTime = .custom(seconds: 2)
        toastViewConfig.angularResistance = 1
        
        CFNotify.present(config: toastViewConfig, view: toastView)
    }
    
    static func fail(with text:String) {
        let toastView = CFNotifyView.toastWith(text: text,
                                               theme: .fail(.dark))
        toastView.backgroundColor = UIColor.init(hexString: "f3704b")
        var toastViewConfig = CFNotify.Config()
        toastViewConfig.initPosition = .bottom(.center)
        toastViewConfig.appearPosition = .bottom
        toastViewConfig.thresholdDistance = 30
        toastViewConfig.hideTime = .custom(seconds: 2)
        toastViewConfig.angularResistance = 1
        
        CFNotify.present(config: toastViewConfig, view: toastView)
    }
    
}
