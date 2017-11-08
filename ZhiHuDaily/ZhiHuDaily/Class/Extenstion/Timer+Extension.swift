//
//  Timer+Extension.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/8.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation

extension Timer {
    public static func runThisEvery(seconds: TimeInterval, handler: @escaping (Timer?) -> Void) -> Timer {
        let fireDate = CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, seconds, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }
}
