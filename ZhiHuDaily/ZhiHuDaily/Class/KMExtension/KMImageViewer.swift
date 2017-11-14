//
//  KMImageViewer.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/14.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit

class KMImageViewer: UIViewController {

    fileprivate let scrollView = UIScrollView()
    
    fileprivate let imageView = UIImageView()
    
    var dismissCallBack : (() -> Void)?
    
    
    /// 保存原windowLevel
    private var originWindowLevel: UIWindowLevel!
    
    /// 本VC的presentingViewController
    private let presentingVC: UIViewController
    
    /// 捏合手势放大图片时的最大允许比例
    public var imageMaximumZoomScale: CGFloat = 2.0 {
        didSet {
            self.scrollView.maximumZoomScale = imageMaximumZoomScale
        }
    }
    
    /// 双击放大图片时的目标比例
    public var imageZoomScaleForDoubleTap: CGFloat = 2.0
    
    /// 记录pan手势开始时imageView的位置
    private var beganFrame = CGRect.zero
    
    /// 记录pan手势开始时，手势位置
    private var beganTouch = CGPoint.zero
    
    /// 加载进度指示器
    private let progressView = KMImageViewerProgressView()
    
    /// 取图片适屏size
    private var fitSize: CGSize {
        guard let image = imageView.image else {
            return CGSize.zero
        }
        let width = scrollView.bounds.width
        let scale = image.size.height / image.size.width
        return CGSize(width: width, height: scale * width)
    }
    
    /// 取图片适屏frame
    private var fitFrame: CGRect {
        let size = fitSize
        let y = (scrollView.bounds.height - size.height) > 0 ? (scrollView.bounds.height - size.height) * 0.5 : 0
        return CGRect(x: 0, y: y, width: size.width, height: size.height)
    }
    
    /// 计算contentSize应处于的中心位置
    private var centerOfContentSize: CGPoint {
        let deltaWidth = view.bounds.width - scrollView.contentSize.width
        let offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0
        let deltaHeight = view.bounds.height - scrollView.contentSize.height
        let offsetY = deltaHeight > 0 ? deltaHeight * 0.5 : 0
        return CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX,
                       y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    
    // MARK: - 公开方法
    /// 初始化，传入用于present出本VC的VC，以及实现了PhotoBrowserDelegate协议的对象
    public init(showByViewController presentingVC: UIViewController, imageURL: URL, re,dissmiss:(() -> Void)) {
        self.dismissCallBack = dismiss
        self.presentingVC = presentingVC
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if DEBUG
            dismissCallBack ? dismissCallBack() : nil
            print("deinit:\(self)")
        #endif
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension KMImageViewer {
    func createUI() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        scrollView.addSubview(imageView)
        imageView.clipsToBounds = true
        
        view.addSubview(progressView)
        progressView.isHidden = true
        
        // 长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        view.addGestureRecognizer(longPress)
        
        // 双击手势
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        // 单击手势
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(onSingleTap))
        view.addGestureRecognizer(singleTap)
        singleTap.require(toFail: doubleTap)
        
        // 拖动手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        scrollView.addGestureRecognizer(pan)
        
    }
    
    /// 布局
    private func doLayout() {
        scrollView.frame = view.bounds
        scrollView.setZoomScale(1.0, animated: false)
        imageView.frame = fitFrame
        progressView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
    
    /// 加载图片
    private func loadImage(withPlaceholder placeholder: UIImage?, url: URL?) {
        self.progressView.isHidden = false
        weak var weakSelf = self
        imageView.kf.setImage(with: url, placeholder: placeholder, options: nil, progressBlock: { (receivedSize, totalSize) in
            if totalSize > 0 {
                weakSelf?.progressView.progress = CGFloat(receivedSize) / CGFloat(totalSize)
            }
        }, completionHandler: { (image, error, cacheType, url) in
            weakSelf?.progressView.isHidden = true
            weakSelf?.doLayout()
        })
    }
    
    /// 展示
    public func show() {
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
        self.modalPresentationCapturesStatusBarAppearance = true
        presentingVC.present(self, animated: true, completion: nil)
    }
    
}
//MARK: - @objc
@objc extension KMImageViewer {
    /// 响应单击
    func onSingleTap() {
        handelSingleTap()
    }
    
    /// 响应双击
    func onDoubleTap(_ dbTap: UITapGestureRecognizer) {
        // 如果当前没有任何缩放，则放大到目标比例
        // 否则重置到原比例
        if scrollView.zoomScale == 1.0 {
            // 以点击的位置为中心，放大
            let pointInView = dbTap.location(in: imageView)
            let w = scrollView.bounds.size.width / imageZoomScaleForDoubleTap
            let h = scrollView.bounds.size.height / imageZoomScaleForDoubleTap
            let x = pointInView.x - (w / 2.0)
            let y = pointInView.y - (h / 2.0)
            scrollView.zoom(to: CGRect(x: x, y: y, width: w, height: h), animated: true)
        } else {
            scrollView.setZoomScale(1.0, animated: true)
        }
    }
    
    /// 响应拖动
    func onPan(_ pan: UIPanGestureRecognizer) {
        guard imageView.image != nil else {
            return
        }
        switch pan.state {
        case .began:
            beganFrame = imageView.frame
            beganTouch = pan.location(in: scrollView)
        case .changed:
            // 拖动偏移量
            let translation = pan.translation(in: scrollView)
            let currentTouch = pan.location(in: scrollView)
            
            // 由下拉的偏移值决定缩放比例，越往下偏移，缩得越小。scale值区间[0.3, 1.0]
            let scale = min(1.0, max(0.3, 1 - translation.y / view.bounds.height))
            
            let width = beganFrame.size.width * scale
            let height = beganFrame.size.height * scale
            
            // 计算x和y。保持手指在图片上的相对位置不变。
            // 即如果手势开始时，手指在图片X轴三分之一处，那么在移动图片时，保持手指始终位于图片X轴的三分之一处
            let xRate = (beganTouch.x - beganFrame.origin.x) / beganFrame.size.width
            let currentTouchDeltaX = xRate * width
            let x = currentTouch.x - currentTouchDeltaX
            
            let yRate = (beganTouch.y - beganFrame.origin.y) / beganFrame.size.height
            let currentTouchDeltaY = yRate * height
            let y = currentTouch.y - currentTouchDeltaY
            
            imageView.frame = CGRect(x: x, y: y, width: width, height: height)
            
            //可依scale值改变背景蒙板alpha值
            handelPan(with: scale)
        case .ended, .cancelled:
            if pan.velocity(in: view).y > 0 {
                // dismiss
                onSingleTap()
            } else {
                // 取消dismiss
                endPan()
            }
        default:
            endPan()
        }
    }
    
    private func endPan() {
        
        handelPan(with: 1.0)
        
        // 如果图片当前显示的size小于原size，则重置为原size
        let size = fitSize
        let needResetSize = imageView.bounds.size.width < size.width
            || imageView.bounds.size.height < size.height
        UIView.animate(withDuration: 0.25) {
            self.imageView.center = self.centerOfContentSize
            if needResetSize {
                self.imageView.bounds.size = size
            }
        }
    }
    
    /// 响应长按
    func onLongPress(_ press: UILongPressGestureRecognizer) {
        if press.state == .began, let image = imageView.image {
           handelLongPress(with: image)
        }
    }
}

extension KMImageViewer {
    func handelSingleTap() {
        
    }
    
    func handelPan(with scale : CGFloat) {
        
    }
    
    func handelLongPress(with image : UIImage) {
        
    }
}

extension KMImageViewer {
    /// 遮盖状态栏。以改变windowLevel的方式遮盖
    private func coverStatusBar(_ cover: Bool) {
        let win = view.window ?? UIApplication.shared.keyWindow
        guard let window = win else {
            return
        }
        
        if originWindowLevel == nil {
            originWindowLevel = window.windowLevel
        }
        if cover {
            if window.windowLevel == UIWindowLevelStatusBar + 1 {
                return
            }
            window.windowLevel = UIWindowLevelStatusBar + 1
        } else {
            if window.windowLevel == originWindowLevel {
                return
            }
            window.windowLevel = originWindowLevel
        }
    }
}

extension KMImageViewer : UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.center = centerOfContentSize
    }
}

extension KMImageViewer : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 只响应pan手势
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        let velocity = pan.velocity(in: view)
        // 向上滑动时，不响应手势
        if velocity.y < 0 {
            return false
        }
        // 横向滑动时，不响应pan手势
        if abs(Int(velocity.x)) > Int(velocity.y) {
            return false
        }
        // 向下滑动，如果图片顶部超出可视区域，不响应手势
        if scrollView.contentOffset.y > 0 {
            return false
        }
        return true
    }
}

// MARK: - 转场动画

extension KMImageViewer: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let imageV = UIImageView(image: imageView.image)
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        // 创建animator
        let animator = ScaleAnimator(startView: relatedView, endView: imageView, scaleView: imageV)
        presentationAnimator = animator
        return animator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let imageV = UIImageView(image: imageView.image)
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        return ScaleAnimator(startView: imageView, endView: relatedView, scaleView: imageV)
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let coordinator = ScaleAnimatorCoordinator(presentedViewController: presented, presenting: presenting)
        coordinator.currentHiddenView = relatedView
        animatorCoordinator = coordinator
        return coordinator
    }
}

