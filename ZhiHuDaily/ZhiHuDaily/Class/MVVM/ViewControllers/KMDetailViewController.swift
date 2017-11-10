//
//  KMDetailViewController.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/8.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift
import NSObject_Rx
class KMDetailViewController: UIViewController {

    var contentView : KMDetailWebView!
    var previousContentView : KMDetailWebView!
    var idArr = [Int]()
    var previousId = 0
    var nextId = -1
    var statusBarView = UIView().then { (v) in
        v.frame = KStatusBarFrame
        v.backgroundColor = .white
        v.isHidden = false
    }
    
    var imageArr = [String]()
    
    fileprivate let vm = KMDetailViewModel()
    
    var id = Int() {
        didSet {
            
            if isViewLoaded {
                vm.newsId.value = id
            }
            
            for item in idArr.enumerated() {
                if id == item.element {
                    let index = item.offset
                    if index == 0 {
                        //第一条
                        previousId = 0
                        nextId = idArr[index + 1]
                    }else if index == idArr.count - 1 {
                        //最后一条
                        nextId = -1
                        previousId = idArr[index - 1]
                    }else {
                        previousId = idArr[index - 1]
                        nextId = idArr[index + 1]
                    }
                    break;
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
        bindViewModel()
        
        vm.newsId.value = id
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollViewDidScroll(contentView.scrollView)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.slideMenuController()?.addLeftGestures()
    }

}

extension KMDetailViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        avoidAutomaticDown64()
        km_setNavigationBarAlpha(1)
        km_setNavigationBarBackgroundColor(UIColor.FlatUI.flatOrange)
        
        contentView = KMDetailWebView(frame: view.bounds)
        contentView.navigationDelegate = self
        contentView.scrollView.delegate = self
       
        previousContentView = KMDetailWebView(frame: CGRect(
            x: 0,
            y: -KScreenH,
            width: KScreenW,
            height: KScreenH
        ))
        
        view.addSubviews([contentView, previousContentView, statusBarView])
        
        updateLabelText()
    }
    
    func bindViewModel() {
        vm
            .newsDetail
            .subscribe(onNext: { (detailModel) in
            self.bindDetailModel(detailModel)
        })
            .disposed(by: rx.disposeBag)
    }
    
    func bindDetailModel(_ detail : StoryDetailModel) {
        if let image = detail.image {
            contentView.img.kf.setImage(with: URL.init(string: image))
            contentView.titleLabel.text = detail.title
        }else {
            contentView.img.isHidden = true
            contentView.previousLabel.textColor = UIColor.init(hexString: "777777")
        }
        
        if let image_source = detail.image_source {
            contentView.imageLabel.text = "图片: " + image_source
        }
        if (detail.title?.characters.count)! > 16 {
            contentView.titleLabel.frame = CGRect(x: 15, y: 120, width: KScreenW - 30, height: 55)
        }
        OperationQueue.main.addOperation {
            self.loadDetailHTML(model: detail)
        }
    }
    
}

fileprivate extension KMDetailViewController {
    
    func updateLabelText() {
        if previousId == 0 {
            contentView.previousLabel.text = "已经是第一篇了"
        } else {
            contentView.previousLabel.text = "载入上一篇"
        }
        if nextId == -1 {
            contentView.nextLabel.text = "已经是最后一篇了"
        } else {
            contentView.nextLabel.text = "载入下一篇"
        }
    }
    
    
    // 加载HTML网页
    func loadDetailHTML(model: StoryDetailModel) {
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
        self.contentView.loadHTMLString(html, baseURL: nil)
    }
    
    func changeContentView(with willShowId : Int) {
        contentView.removeFromSuperview()
        previousContentView.scrollView.delegate = self
        previousContentView.navigationDelegate = self
        contentView = previousContentView
        id = willShowId
        updateLabelText()
        previousContentView = KMDetailWebView(frame: CGRect(
            x: 0,
            y: -KScreenH,
            width: KScreenW,
            height: KScreenH
        ))
        view.addSubview(previousContentView)
        scrollViewDidScroll(contentView.scrollView)
    }
 
    func showImageViewer(with imageUrl : String) {
        log.debug("\(imageUrl)")
    }
    
}

extension KMDetailViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        
        contentView.img.km.y = offsetY
        contentView.img.km.height = 200 - offsetY
        contentView.maskImg.frame = CGRect(
            x: 0,
            y: contentView.img.km.height - 100,
            width: KScreenW,
            height: 100
        )
        if offsetY > 180 {
            view.bringSubview(toFront: statusBarView)
            statusBarView.isHidden = false
            UIApplication.shared.statusBarStyle = .default
        }else {
            statusBarView.isHidden = true
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= -60 {
            if previousId > 0 {
                previousContentView.frame = CGRect(
                    x: 0,
                    y: -KScreenH,
                    width: KScreenW,
                    height: KScreenH
                )
                UIView.animate(withDuration: 0.3, animations: {
                    self.contentView.transform = CGAffineTransform(
                        translationX: 0,
                        y: KScreenH
                    )
                    self.previousContentView.transform = CGAffineTransform(
                        translationX: 0,
                        y: KScreenH
                    )
                }, completion: { (ret) in
                    if ret {
                        self.changeContentView(with: self.previousId)
                    }
                })
            }
        }
        if offsetY - 50 + KScreenH >= scrollView.contentSize.height {
            if nextId > 0 {
                previousContentView.frame = CGRect(
                    x: 0,
                    y: KScreenH,
                    width: KScreenW,
                    height: KScreenH
                )
                UIView.animate(withDuration: 0.3, animations: {
                    self.previousContentView.transform = CGAffineTransform(
                        translationX: 0,
                        y: -KScreenH
                    )
                    self.contentView.transform = CGAffineTransform(
                        translationX: 0,
                        y: -KScreenH
                    )
                }, completion: { (ret) in
                    if ret {
                        self.changeContentView(with: self.nextId)
                    }
                })
            }
        }
    }
}

extension KMDetailViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url?.absoluteString {
            if url == "about:blank" {
                decisionHandler(.allow)
            }
            
            if url.hasPrefix("km:imageClick:") {
                //图片点击
                let imageUrl = url.replacingOccurrences(of: "km:imageClick:", with: "")
                showImageViewer(with: imageUrl)
            }
            if url.hasPrefix("http") {
                //打开浏览器
                UIApplication.shared.openURL(navigationAction.request.url!)
            }
            decisionHandler(.cancel)
        }else {
           decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        contentView.waitView.removeFromSuperview()
        //调整下一篇文字位置
        webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] (result, error) in
            if let height = result as? CGFloat {
                self?.contentView.nextLabel.frame.origin.y = height + 50
            }
        }
        //获取图片链接
        let getImagesJS = """
                            function getImages(){\
                            var objs = document.querySelectorAll(\"body img\");\
                            var imgScr = '';\
                            for(var i=0;i<objs.length;i++){\
                            imgScr = imgScr + objs[i].src + '+';\

                            objs[i].onclick=function(){\
                            if(this.alt==''){\
                                document.location=\"km:imageClick:\"+this.src;\
                            }\
                            };\
                            };\
                            return imgScr;\
                            };
                        """
        webView.evaluateJavaScript(getImagesJS, completionHandler: nil)
        
        
        webView.evaluateJavaScript("getImages()") { [weak self] (result, error) in
            if let resultString = result as? String {
                self?.imageArr = resultString.components(separatedBy: "+").filter({
                    $0.hasPrefix("http")
                })
                log.debug("\(self?.imageArr)")
            }
        }
        
//        //图片添加点击标签
//        let imageClickJS = """
//                            function registerImageClickAction(){\
//                                 var imgs = document.querySelectorAll(\"body img\");\
//                                 var length = imgs.length;\
//                                 for(var i=0;i<length;i++){\
//                                 img = imgs[i];\
//                                 img.onclick=function(){\
//                                 window.location.href='image-preview:'+this.src}\
//                                 }\
//                                 }
//                            """
//        webView.evaluateJavaScript(imageClickJS, completionHandler: nil)
        
    }
}

