//
//  KMRefreshTitleView.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/4.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit
import Then
import SnapKit
class KMRefreshTitleView: UIView {
    
    var text : NSAttributedString? {
        didSet {
            if label != nil {
                label?.attributedText = text
                layoutIfNeeded()
            }
        }
    }
    
    fileprivate let circleLayer = CAShapeLayer()
   
    fileprivate let indicatorView = UIActivityIndicatorView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
    }
    fileprivate var label : UILabel?
    
    fileprivate var refreshView : UIView?

    fileprivate var refreshing = false
    fileprivate var endRef = false
    
    init(with text : NSAttributedString){
        super.init(frame: .zero)
        self.text = text
        self.frame = CGRect(x: 0, y: 0, width: 160, height: 44)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.position = CGPoint(x: (refreshView?.width)!/2.0, y: (refreshView?.height)!/2.0)
        indicatorView.center = CGPoint(x: (refreshView?.width)!/2.0, y: (refreshView?.height)!/2.0)
    }
    
}

fileprivate extension KMRefreshTitleView {
    func setup() {
        setupLabel()
        setupRefreshView()
        createCircleLayer()
    }
    
    func setupLabel() {
        label = UILabel().then({
//            $0.textAlignment = .center
//            $0.font = Font.bold(size: 15)
//            $0.textColor = .white
            $0.attributedText = self.text
        })
        addSubview(label!)
        label?.snp.makeConstraints({ (make) in
            make.top.bottom.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(100)
        })
    }
    
    func setupRefreshView() {
        refreshView = UIView()
        addSubview(refreshView!)
        refreshView?.snp.makeConstraints({ (make) in
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.right.equalTo(label!.snp.left)
        })
    }
    
    func createCircleLayer() {
        circleLayer.path = UIBezierPath(arcCenter: CGPoint(x: 8, y: 8),
                                        radius: 8,
                                        startAngle: CGFloat(Double.pi/2),
                                        endAngle: CGFloat(Double.pi/2 + 2*Double.pi),
                                        clockwise: true).cgPath
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeStart = 0.0
        circleLayer.strokeEnd = 0.0
        circleLayer.lineWidth = 1.0
        circleLayer.lineCap = kCALineCapRound
        circleLayer.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
        circleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        refreshView?.layer.addSublayer(circleLayer)
    }
}

extension KMRefreshTitleView {
    func pullToRefresh(progress:CGFloat) {
//        log.debug("progress:\(progress)")
        circleLayer.strokeEnd = progress
    }
    
    func beginRefresh(begin:@escaping ()->Void) {
        if refreshing {
            return
        }
        
        refreshing = true
        circleLayer.removeFromSuperlayer()
        refreshView?.addSubview(indicatorView)
        indicatorView.startAnimating()
        begin()
    }
    
    func endRefresh() {
        refreshing = false
        indicatorView.stopAnimating()
        indicatorView.removeFromSuperview()
        circleLayer.strokeEnd = 0
    }
    
    func reset() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.createCircleLayer()
        }
    }
}

