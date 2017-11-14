//
//  KMDetailWebView.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/10.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit
import WebKit
class KMDetailWebView: WKWebView {

    var img = UIImageView().then { (v) in
        v.frame = CGRect(x: 0, y: 0, width: KScreenW, height: 200)
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
    }
    var maskImg = UIImageView().then { (v) in
        v.frame = CGRect(x: 0, y: 100, width: KScreenW, height: 100)
        v.image = R.image.home_Image_Mask()
    }
    var titleLabel = UILabel().then { (v) in
        v.frame = CGRect(x: 15, y: 150, width: KScreenW - 30, height: 26)
        v.font = Font.bold(size: 21)
        v.numberOfLines = 2
        v.textColor = .white
    }
    var imageLabel = UILabel().then { (v) in
        v.frame = CGRect(x: 15, y: 180, width: KScreenW - 30, height: 16)
        v.font = Font.size(size: 10)
        v.textAlignment = .right
        v.textColor = .white
    }
    var previousLabel = UILabel().then { (v) in
        v.frame = CGRect(x: 15, y: -30, width: KScreenW - 30, height: 20)
        v.font = Font.size(size: 15)
        v.text = "载入上一篇"
        v.textAlignment = .center
        v.textColor = .white
    }
    var nextLabel = UILabel().then { (v) in
        v.frame = CGRect(x: 15, y: KScreenH + 30, width: KScreenW - 30, height: 20)
        v.font = Font.size(size: 15)
        v.text = "载入下一篇"
        v.textAlignment = .center
        v.textColor = UIColor.init(hexString: "777777")
    }
    var waitView = UIView().then { (v) in
        v.backgroundColor = .white
        v.frame = CGRect(x: 0, y: 0, width: KScreenW, height: KScreenH)
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.center = v.center
        indicatorView.startAnimating()
        v.addSubview(indicatorView)
    }

    init(frame : CGRect) {
        // 设置内容自适应
        let js = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkUserScript = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let config = WKWebViewConfiguration()
        let wkUControl = WKUserContentController()
        wkUControl.addUserScript(wkUserScript)
        config.userContentController = wkUControl
        
        super.init(frame: frame, configuration: config)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

fileprivate extension KMDetailWebView {
    
    func setupUI() {
        img.addSubview(maskImg)
        scrollView.addSubviews([img, titleLabel, imageLabel, previousLabel, nextLabel, waitView])
        scrollView.clipsToBounds = true
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.contentInset = UIEdgeInsets.zero
        
        backgroundColor = .white
    }
    
}

fileprivate extension KMDetailWebView {
    /// 加载HTML网页
    fileprivate func loadDetailHTML(model: StoryDetailModel) {
        guard let css = model.css, let body = model.body else {
            return
        }
        var html = "<html>"
        html += "<head>"
        css.forEach { html += "<link rel=\"stylesheet\" href=\($0)>" }
        html += "<style>img{max-width:320px !important;}</style>"
        html += "<body>"
        html += body
        html += "</body>"
        html += "</head>"
        html += "</html>"
        self.loadHTMLString(html, baseURL: nil)
    }
}
