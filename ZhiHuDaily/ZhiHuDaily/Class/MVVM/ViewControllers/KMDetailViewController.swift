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
import KSPhotoBrowser
import YYWebImage
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
        UIApplication.shared.statusBarStyle = .lightContent
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
        
        imageArr.removeAll()
        
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
 
    func showImageViewer(with index : Int, imageFrame : CGRect) {
//        log.debug(" \(index)     \(imageFrame)")
        
        if imageArr.count >= index {
            let url = imageArr[index]
            log.debug("\(url)")
            let imageView = UIImageView(frame: imageFrame)
            imageView.yy_setImage(with: URL.init(string: url), placeholder: nil)
//            imageView.kf.setImage(with: URL.init(string: url))
            contentView.addSubview(imageView)
            let photoItem = KSPhotoItem.init(sourceView: imageView, imageUrl: URL.init(string: url)!)
            let browser = KSPhotoBrowser.init(photoItems: [photoItem], selectedIndex: 0)
            browser.dismissalStyle = .rotation
            browser.backgroundStyle = .blur
            browser.loadingStyle = .determinate
            browser.bounces = true
            browser.dismissCallback = {
                imageView.removeFromSuperview()
            }
            browser.show(from: self)
        }
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
                return
            }
            if url.hasPrefix("km:imageClick") {
                //图片点击
                
                let elements = url.components(separatedBy: ":km:")
                
                let imageIndex = elements[1].int!
                let imageX = elements[2].cgFloat()!
                let imageY = elements[3].cgFloat()!
                let imageW = elements[4].cgFloat()!
                let imageH = elements[5].cgFloat()!
                
                let imageFrame = CGRect(x: imageX, y: imageY, width: imageW, height: imageH)
                DispatchQueue.main.async {
                    self.showImageViewer(with: imageIndex, imageFrame: imageFrame)
                }
                
                decisionHandler(.cancel)
                return
            }
            if url.hasPrefix("http") && navigationAction.navigationType == .linkActivated {
                //打开浏览器
                UIApplication.shared.openURL(navigationAction.request.url!)
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
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
        
        webView.evaluateJavaScript(imageJS(), completionHandler: nil)
        
        //给图片添加自定义的点击标签
        webView.evaluateJavaScript("setImage();", completionHandler: nil)
        
        //获取图片url数组
        webView.evaluateJavaScript("getAllImageUrl();") { [weak self] (result, error) in
            if let resultString = result as? String {
                let arr = resultString.components(separatedBy: ",")
                self?.imageArr = arr
//                log.debug("\(arr)")
            }
        }
        
        //禁止放大缩小
        let scalableJs = """
                    var script = document.createElement('meta');
                    script.name = 'viewport';
                    script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";
                    document.getElementsByTagName('head')[0].appendChild(script);
                """
        webView.evaluateJavaScript(scalableJs, completionHandler: nil)
    }
}
extension KMDetailViewController {
    func imageJS() -> String {
        return """
                    function setImage(){\
                    var imgs = document.getElementsByTagName(\"img\");\
                    for (var i=0;i<imgs.length;i++){\
                    imgs[i].setAttribute(\"onClick\",\"imageClick(\"+i+\")\");\
                    }\
                    }\
                    function imageClick(i){\
                    var rect = getImageRect(i);\
                    var url=\"km:imageClick\"+":km:\"+i+\":km:\"+rect;\
                    document.location = url;\
                    }\
                    function getImageRect(i){\
                    var imgs = document.getElementsByTagName(\"img\");\
                    var rect;\
                    rect = imgs[i].getBoundingClientRect().left+\":km:\";\
                    rect = rect+imgs[i].getBoundingClientRect().top+\":km:\";\
                    rect = rect+imgs[i].width+\":km:\";\
                    rect = rect+imgs[i].height;\
                    return rect;\
                    }\
                    function getAllImageUrl(){\
                    var imgs = document.getElementsByTagName(\"img\");\
                    var urlArray = [];\
                    for (var i=0;i<imgs.length;i++){\
                    var src = imgs[i].src;\
                    urlArray.push(src);\
                    }\
                    return urlArray.toString();\
                    }
            """
    }
}
