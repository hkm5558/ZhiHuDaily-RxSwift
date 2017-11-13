//
//  KMImageViewer.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/13.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation

fileprivate let km_screenW = UIScreen.main.bounds.width
fileprivate let km_screenH = UIScreen.main.bounds.height

fileprivate let defaultSourceFrame = CGRect(
    x: KMImageViewerConstant.screenW/2.0 - 1,
    y: KMImageViewerConstant.screenH/2.0 - 1,
    width: 2,
    height: 2
    )

fileprivate extension Selector {
    static let doubleTap = #selector(KMImageViewer.didDoubleTap(_:))
    static let didSingleTap = #selector(KMImageViewer.didSingleTap(_:))
    static let didLongPress = #selector(KMImageViewer.didLongPress(_:))
    static let didPan = #selector(KMImageViewer.didPan(_:))
}


class KMImageViewer : UIViewController {
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.delegate = self
        return scrollView
    }()
    
    var currentIndex : Int
    
    var photoItems : [KMPhotoItem]
    
    
    fileprivate var _presented = false
    
    fileprivate var _startLocation = CGPoint.zero
    
    init(photoItems: [KMPhotoItem], selectedIndex index : Int) {
        currentIndex = index
        self.photoItems = photoItems
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        modalTransitionStyle = .coverVertical
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handelWillAppear()
    }
}

extension KMImageViewer {
    func createUI() {
        view.backgroundColor = .clear
        
        var rect = view.bounds
        rect.origin.x -= KMImageViewerConstant.photoViewPadding
        rect.size.width += 2*KMImageViewerConstant.photoViewPadding
        scrollView.frame = rect
        view.addSubview(scrollView)
        
        let contentSize = CGSize(
            width: rect.width * CGFloat(photoItems.count),
            height: rect.height
        )
        scrollView.contentSize = contentSize
        
        addGestureRecognizer()
        
        let contentOffset = CGPoint(
            x: scrollView.frame.width * CGFloat(currentIndex) ,
            y: 0
        )
        scrollView.setContentOffset(contentOffset, animated: false)
    }
    
    func handelWillAppear() {
        //没有对应下标
        guard photoItems.count - 1 >= currentIndex else {
            return
        }
        
    }
    
}

extension KMImageViewer {
    func addGestureRecognizer() {
        // 双击
        let doubleTap = UITapGestureRecognizer(target: self, action: .doubleTap)
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        // 单击
        let singleTap = UITapGestureRecognizer(target: self, action: .didSingleTap)
        singleTap.numberOfTapsRequired = 1
        singleTap.require(toFail: doubleTap)
        view.addGestureRecognizer(singleTap)
        
        // 长按
        let longPress = UILongPressGestureRecognizer(target: self, action: .didLongPress)
        view.addGestureRecognizer(longPress)
        
        // 滑动
        let pan = UIPanGestureRecognizer(target: self, action: .didPan)
        self.view.addGestureRecognizer(pan)
    }
}

@objc extension KMImageViewer {
    func didDoubleTap(_ gesture:UITapGestureRecognizer) {
        
    }
    
    func didSingleTap(_ gesture:UITapGestureRecognizer) {
        
    }
    
    func didLongPress(_ gesture:UILongPressGestureRecognizer){
        
    }
    func didPan(_ gesture:UIPanGestureRecognizer){
        
    }
    func performScaleWithPan(_ pan:UIPanGestureRecognizer) {
        
    }
}


extension KMImageViewer : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

extension KMImageViewer {
    class func show(showByViewController presentingVC: UIViewController, image : UIImage, sourceFrame : CGRect = defaultSourceFrame) {
        
    }
    class func show(showByViewController presentingVC: UIViewController, imageURL : URL, sourceFrame : CGRect = defaultSourceFrame) {
        
    }
}



