//
//  KMThemeViewController.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/15.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx
import YYImage
import YYWebImage
fileprivate extension Selector {
    static let didTapLeft = #selector(KMThemeViewController.didTapLeftBarButton)
}

class KMThemeViewController: UIViewController {

    var themeModel : ThemeModel!
    
    var titleView : KMRefreshTitleView?
    
    @IBOutlet var topImageView: UIImageView!
    
    @IBOutlet var topImageTop: NSLayoutConstraint!
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        avoidAutomaticDown64()
        bindNavigation()
        bindTableView()
        view.backgroundColor = UIColor.CSS.darkSeaGreen
        
        if let imageURL = themeModel.thumbnail {
            topImageView.kf.setImage(with: URL.init(string: imageURL), placeholder: R.image.field_Mask_Bg())
        }
        let effView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .light))
    }
}

extension KMThemeViewController {
    func bindNavigation() {
        let text = themeModel.name!.at.attributed {
            return $0
                .font(Font.bold(size: 15))
                .foreground(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
                .alignment(.center)
        }
        titleView = KMRefreshTitleView(with: text)
        navigationItem.titleView = titleView
        km_setNavigationBarAlpha(0)
        km.addLeftBarButton(R.image.back_White(), .didTapLeft)
        
    }
    func bindTableView() {
        
        let offsetY = tableView
            .rx
            .contentOffset
            .observeOn(MainScheduler.asyncInstance)
            .map({ $0.y })
            .distinctUntilChanged()
        
        offsetY
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { (y) in
            
            if y < -100 {
                self.tableView.contentOffset = CGPoint(x: 0, y: -100)
                return
            }
            
            if y <= 0 {
                self.topImageTop.constant = y
            }
        }).disposed(by: rx.disposeBag)
    }
}

@objc extension KMThemeViewController {
    func didTapLeftBarButton() {
       slideMenuController()?.openLeft()
    }
}
