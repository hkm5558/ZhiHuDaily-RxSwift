//
//  KMHomeViewController.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/2.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
class KMHomeViewController: UIViewController {

    
    var navBackground : UIView?
    
    @IBOutlet var bannerView: KMBannerView!
    
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var tableView: UITableView!
    
    var navAlpha = Variable<CGFloat>(0.0)
    
    
    let vm = KMHomeViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
}
extension KMHomeViewController {
    func setup() {
        
        avoidAutomaticDown64()
        
        bannerView.bannerDelegate = self
        bindNavigation()
        bindViewModel()
        
        tableView
            .rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        
        
    }
    func bindNavigation() {
        let titleView = KMRefreshTitleView.init(with: "今日热闻")
        navigationItem.titleView = titleView
        
        setNavigationBackgroundColor(with: Color.themeBlue)
        
        navBackground = navigationController?.navigationBar.subviews.first
       _ = navBackground?
            .rx.observe(CGFloat.self, "alpha")
            .observeOn(MainScheduler.asyncInstance)
            .filter({ $0 != self.navAlpha.value })
            .subscribe(onNext: { [unowned self] (alpha) in
                self.navBackground?.alpha = self.navAlpha.value
            })
            .disposed(by: rx.disposeBag)
        navAlpha
            .asObservable()
            .subscribe(onNext: { [unowned self] (alpha) in
               self.navBackground?.alpha = alpha
            })
            .disposed(by: rx.disposeBag)
    }
    
    func bindViewModel() {
        let inputStuff = KMHomeViewModel.HomeInput()
        let outputStuff = vm.transform(input: inputStuff)
        
        
        outputStuff
            .top_stories
            .asObservable()
            .filter({ $0.count != 0 })
            .subscribe(onNext: { [unowned self] (top_stories) in
                    var arr = top_stories
                    arr.insert(arr.last!, at: 0)
                    arr.append(arr[1])
                    self.bannerView.top_stories.value = arr
                    self.pageControl.numberOfPages = arr.count
            })
            .disposed(by: rx.disposeBag)

        outputStuff.loadNewDataCommand.onNext(0)
        
    }
    
}

extension KMHomeViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bannerView.offsetY.value = scrollView.contentOffset.y.double
        var alpha = scrollView.contentOffset.y / 200.0
        alpha > 1.0 ? alpha = 1.0 : nil
        alpha < 0.0 ? alpha = 0.0 : nil
        navAlpha.value = alpha
    }
}

extension KMHomeViewController : BannerDelegate {
    func selectedItem(model: Story) {
        log.debug("\(model)")
    }
    func scrollTo(index: Int) {
        pageControl.currentPage = index
    }
}
