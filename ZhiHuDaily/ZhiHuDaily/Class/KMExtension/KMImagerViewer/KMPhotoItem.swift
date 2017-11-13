//
//  KMPhotoItem.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/13.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
class KMPhotoItem {
    public var thunbImage: UIImage? // 缩略图
    public var image: UIImage?
    public var imageURL: URL?
    public var finished: Bool = false
    public var sourceView: UIView?
    public var sourceFrame: CGRect?
    public init() {
        
    }
}
