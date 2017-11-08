//
//  UINavigationBar+KMExtension.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/8.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    var km_hidden : Bool {
        set {
            subviews.first?.isHidden = newValue
        }
        get {
            if let first = subviews.first {
                return first.isHidden
            }
            return false
        }
    }
    
    
    var km_translationY : CGFloat {
        set {
            self.transform = CGAffineTransform(translationX: 0, y: newValue)
        }
        get {
            return self.transform.ty
        }
    }
    
    var km_aplha : CGFloat {
        set {
            subviews.first?.alpha = newValue
        }
        get {
            if let first = subviews.first {
                return first.alpha
            }
            return 0
        }
    }
    
    var km_shadowImageHidden : Bool {
        set {
            shadowImage = newValue ? UIImage() : nil
        }
        get {
            return shadowImage != nil
        }
    }
    
    var km_color : UIColor? {
        set {
            if let color = newValue {
                setBackgroundImage(UIImage(), for: .default)
                backgroundColor = color
                barTintColor = color
                subviews.first?.backgroundColor = color
                subviews.first?.tintColor = color
//                setBackgroundImage(UIImage.init(color: color, size: bounds.size), for: .default)
            }
        }
        get {
            return backIndicatorImage != nil ? UIColor.init(patternImage: backIndicatorImage!) : nil
        }
    }
    
    
}
