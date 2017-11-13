//
//  KMPhotoView.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/13.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit

class KMPhotoView: UIScrollView {

    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.darkGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var progressLayer: KMImageViewerProgressLayer = {
        let shapeLayer = KMImageViewerProgressLayer(frame: CGRect(
            x: 0,
            y: 0,
            width: 40,
            height: 40
        ) )
        shapeLayer.isHidden = true
        return shapeLayer
    }()
    var photoItem: KMPhotoItem?

    weak var _imageManager : KMImageViewerManagerProtocol?
    
    init(frame: CGRect, imageManager : KMImageViewerManagerProtocol) {
        self._imageManager = imageManager
        super.init(frame: frame)
        create()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KMPhotoView {
    func create() {
        backgroundColor = .clear
        bouncesZoom = true
        maximumZoomScale = CGFloat(KMImageViewerConstant.photoViewMaxScale)
        isMultipleTouchEnabled = true
        showsHorizontalScrollIndicator = true
        showsVerticalScrollIndicator = true
        delegate = self
        
        addSubview(imageView)
        resizeImageView()
        layer.addSublayer(progressLayer)
        progressLayer.position = CGPoint(
            x: frame.width/2,
            y: frame.height/2
        )
    }
}

extension KMPhotoView {
    func setItem(with item : KMPhotoItem?, determinate : Bool) {
        photoItem = item
        _imageManager?.cancelImageRequest(with: self.imageView)
        if let photoItem = photoItem {
            if let image = photoItem.image {
                imageView.image = image
                photoItem.finished = true
                progressLayer.stopSpin()
                progressLayer.isHidden = true
                resizeImageView()
                return
            }
            
            determinate ? nil : progressLayer.startSpin()
            imageView.image = item?.thunbImage
            
            _imageManager?.setImage(with: imageView, photoItem.imageURL!, photoItem.thunbImage, { (receivedSize, expectedSize) in
                
            }, { (image, url, error) in
                
            })
        }
    }
}


extension KMPhotoView {
    /// 计算imageView显示位置
    func resizeImageView(){
        if let image = imageView.image {
            let imageSize = image.size
            let width = imageView.frame.width
            let height = width * (imageSize.height/imageSize.width)
            let rect  = CGRect(
                x: 0,
                y: 0,
                width: width,
                height: height
            )
            imageView.frame = rect
            
            // 如果图片特别长 只显示上半部分
            if height <= bounds.size.height {
                imageView.center = CGPoint(
                    x: bounds.size.width/2,
                    y: bounds.size.height/2
                )
            }else{
                imageView.center = CGPoint(
                    x: bounds.size.width/2,
                    y: height/2
                )
            }
            
        }else{
            let width = frame.width - 2*KMImageViewerConstant.photoViewPadding
            imageView.frame = CGRect(
                x: 0,
                y: 0,
                width: width,
                height: width*2/3
            )
            imageView.center = CGPoint(
                x: bounds.size.width/2,
                y: bounds.size.height/2
            )
        }
        contentSize = imageView.frame.size
    }
}
extension KMPhotoView : UIScrollViewDelegate {
    
}
