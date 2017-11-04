//
//  KMProtocol.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/2.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import UIKit


protocol ViewModelProtocol {
    associatedtype VmInput
    associatedtype VmOutput
    
    func transform(input: VmInput) -> VmOutput
}

protocol BannerDelegate : NSObjectProtocol {
    func selectedItem(model: Story)
    func scrollTo(index: Int)
}
