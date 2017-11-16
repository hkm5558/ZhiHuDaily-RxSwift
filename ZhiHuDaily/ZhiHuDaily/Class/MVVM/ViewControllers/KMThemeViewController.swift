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
    
    let vm = KMThemeViewModel()
    
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var topImageHeight: NSLayoutConstraint!
    

    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        avoidAutomaticDown64()
        bindNavigation()
        bindTableView()
        bindViewModel()
        view.backgroundColor = UIColor.CSS.darkSeaGreen
        
        if let imageURL = themeModel.thumbnail {
            topImageView.kf.setImage(with: URL.init(string: imageURL), placeholder: R.image.field_Mask_Bg())
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension KMThemeViewController {
    func bindNavigation() {
        km.setTitle(themeModel.name)
        km_setNavigationBarAlpha(0)
        km.addLeftBarButton(R.image.back_White(), .didTapLeft)
    }
    func bindTableView() {
        
        tableView.rowHeight = Config.homeRowHeight
        tableView.separatorColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        tableView.layoutMargins = UIEdgeInsetsMake(0, 15, 0, 15)
        tableView.contentInset = UIEdgeInsetsMake(KNavHeight, 0, 0, 0)
        topImageHeight.constant = KNavHeight
        let offsetY = tableView
            .rx
            .contentOffset
            .observeOn(MainScheduler.asyncInstance)
            .map({ $0.y })
            .distinctUntilChanged()
        
        offsetY
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { (y) in

            let minY = -100 + -(KNavHeight)
                
            if y < minY {
                self.tableView.contentOffset = CGPoint(x: 0, y: minY)
                return
            }
            
            if y <= -KNavHeight {
                self.topImageHeight.constant = -y
            }
        }).disposed(by: rx.disposeBag)
        
        tableView
            .rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        vm
            .stories
            .asDriver()
            .map { $0.stories ?? [] }
            .drive(tableView.rx.items(cellIdentifier: "KMStoryListCell", cellType: KMStoryListCell.self)){
                row, model, cell in
                cell.bindStoryModel(with: model)
            }
            .disposed(by: rx.disposeBag)
        tableView
            .rx
            .itemSelected
            .subscribe(onNext: { (indexPath) in
                self.tableView.deselectRow(at: indexPath, animated: true)
                let story = self.vm.stories.value.stories?.item(at: indexPath.row)
                self.pushNewsDetailVC(with: story)
        })
            .disposed(by: rx.disposeBag)
    }
    func bindViewModel() {

        vm
            .stories
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (model) in
                self.tableView.reloadData()
            })
            .disposed(by: rx.disposeBag)
        
        vm.themeId.value = themeModel.id!

    }
    
}

fileprivate extension KMThemeViewController {
    func pushNewsDetailVC(with story : Story?) {
        if let story = story {
            let vc = KMDetailViewController()
            vm.stories.value.stories!.forEach({ (story) in
                vc.idArr.append(story.id!)
            })
            vc.id = story.id!
            self.navigationController?.pushViewController(vc, completion: {
                //                self.slideMenuController()?.removeLeftGestures()
            })
        }
    }
}

extension KMThemeViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}

@objc extension KMThemeViewController {
    func didTapLeftBarButton() {
       slideMenuController()?.openLeft()
    }
}
