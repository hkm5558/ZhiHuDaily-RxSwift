//
//  KMImageViewerKfManager.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/13.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import Kingfisher
class KMImageViewerKfManager : NSObject, KMImageViewerManagerProtocol {
    
    
    func cancelImageRequest(with imageView: UIImageView) {
        imageView.kf.cancelDownloadTask()
    }
    
    func imageFromMemory(with imageURL: URL) -> UIImage? {
        return KingfisherManager
            .shared
            .cache
            .retrieveImageInMemoryCache(forKey: imageURL.absoluteString)
    }
    
    func setImage(with imageView: UIImageView?, _ imageURL: URL, _ placeholder: UIImage?, _ progress: KMImageViewerManagerProtocol.KMImageManagerProgressBlock?, _ completion: KMImageViewerManagerProtocol.KMImageManagerCompletionBlock?) {
        imageView?.kf.setImage(with: imageURL, placeholder: placeholder, options: nil, progressBlock: { (receivedSize, expectedSize) in
            progress?(receivedSize, expectedSize)
        }, completionHandler: { (image, error, _, url) in
            completion?(image, url, error)
        })
    }
    
}
