//
//  UINavigationBar+KMExtension.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/9.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import UIKit

public extension Kunmin where Base : UINavigationBar {
    var isHidden : Bool {
        set(hidden) {
            self.base.subviews.first?.isHidden = hidden
        }
        get {
            if let first = self.base.subviews.first {
                return first.isHidden
            }
            return false
        }
    }
    
    
    var translationY : CGFloat {
        set(y) {
            self.base.transform = CGAffineTransform.init(translationX: 0, y: y)
        }
        get {
            return self.base.transform.ty
        }
    }
    
    var aplha : CGFloat {
        set(aplha) {
            self.base.subviews.first?.alpha = aplha
        }
        get {
            if let first = self.base.subviews.first {
                return first.alpha
            }
            return 0
        }
    }
    
    var shadowImageHidden : Bool {
        set(hidden) {
            self.base.shadowImage = hidden ? UIImage() : nil
        }
        get {
            return self.base.shadowImage != nil
        }
    }
    
    var backgroundColor : UIColor? {
        set(color) {

            //                setBackgroundImage(UIImage(), for: .default)
            //                backgroundColor = color
            self.base.barTintColor = color
            //                subviews.first?.backgroundColor = color
            //                subviews.first?.tintColor = color
            //                setBackgroundImage(UIImage.init(color: color, size: bounds.size), for: .default)

        }
        get {
            return self.base.barTintColor ?? nil
        }
    }
    
}
