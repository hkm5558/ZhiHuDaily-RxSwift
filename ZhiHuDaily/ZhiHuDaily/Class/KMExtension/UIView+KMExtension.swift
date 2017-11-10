//
//  UIView+KMExtension.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/9.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import UIKit
public extension Kunmin where Base : UIView {
    var height : CGFloat {
        set(h) {
            self.base.frame.size.height = h
        }
        get {
            return self.base.frame.size.height
        }
    }
    
    var width : CGFloat {
        set(w) {
            self.base.frame.size.width = w
        }
        get {
            return self.base.frame.size.width
        }
    }
    
    var x : CGFloat {
        set(x) {
            self.base.frame.origin.x = x
        }
        get {
            return self.base.frame.origin.x
        }
    }
    
    var y : CGFloat {
        set(y) {
            self.base.frame.origin.y = y
        }
        get {
            return self.base.frame.origin.y
        }
    }
    
    var centerX : CGFloat {
        set(x) {
            self.base.center = CGPoint(x: x, y: self.base.center.y)
        }
        get {
            return self.base.center.x
        }
    }
    
    var centerY : CGFloat {
        set(y) {
            self.base.center = CGPoint(x: self.base.center.x, y: y)
        }
        get {
            return self.base.center.y
        }
    }
    
    var size : CGSize {
        set(s) {
            self.base.frame.size = s
        }
        get {
            return self.base.frame.size
        }
    }
    
    var left : CGFloat {
        set(left) {
            self.base.frame.origin.x = left
        }
        get {
            return self.base.frame.origin.x
        }
    }
    
    var right : CGFloat {
        set(right) {
            self.base.frame.origin.x = right - self.base.frame.size.width
        }
        get {
            return self.base.frame.origin.x + self.base.frame.size.width
        }
    }
    
    var top : CGFloat {
        set(t) {
            self.base.frame.origin.y = top
        }
        get {
            return self.base.frame.origin.y
        }
    }
    
    var bottom : CGFloat {
        set(b) {
            self.base.frame.origin.y = b - self.base.frame.size.height
        }
        
        get {
            return self.base.frame.origin.y + self.base.frame.size.height
        }
    }
    
    
}
