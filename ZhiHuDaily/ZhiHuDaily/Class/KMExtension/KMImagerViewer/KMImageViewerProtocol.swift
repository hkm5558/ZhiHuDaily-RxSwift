//
//  KMImageViewerProtocol.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/13.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation

protocol KMImageViewerManagerProtocol : NSObjectProtocol{
    
    typealias KMImageManagerProgressBlock = ((_ receivedSize:Int64, _ expectedSize:Int64) -> Void)
    
    typealias KMImageManagerCompletionBlock = ((_ image:UIImage?, _ url:URL?, _ error:NSError?) -> Void)
    
    func setImage(with imageView:UIImageView?, _ imageURL:URL, _ placeholder: UIImage?, _ progress:KMImageManagerProgressBlock?, _ completion:KMImageManagerCompletionBlock?)
    
    func cancelImageRequest(with imageView:UIImageView)
    
    func imageFromMemory(with imageURL:URL) -> UIImage?
}
