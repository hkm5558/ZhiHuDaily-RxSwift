//
//  KMMenuViewController.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/2.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit
import Then
import RxCocoa
import RxSwift
import RxDataSources
import NSObject_Rx
class KMMenuViewController: UIViewController {

    
    var home : UINavigationController!
    
    let vm = KMMeunViewModel()
    
    @IBOutlet var themeList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        bindTableView()
        bindViewModel()
        
    }
}

extension KMMenuViewController {
    func bindViewModel() {
        
        vm
            .themeArr
            .asDriver()
            .asDriver(onErrorJustReturn: [ThemeModel]())
            .drive(themeList.rx.items(cellIdentifier: "KMThemeCell", cellType: KMThemeCell.self)){
                row, model, cell in
                cell.nameLabel.text = model.name
                cell.homeIcon.isHidden = row != 0
                cell.nameLeft.constant = row == 0 ? 50 : 15
            }
            .disposed(by: rx.disposeBag)

        vm
            .loadThemeListCommand
            .onNext(())
    }
    
    func bindTableView() {
        themeList.backgroundColor = UIColor.clear
        themeList.hideEmptyCells()
        themeList
            .rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        themeList
            .rx
            .itemSelected
            .subscribe(onNext: { (indexPath) in
            if indexPath.row == 0 {
                if !(self.slideMenuController()!.mainViewController!.isEqual(self.home)) {
                    self.slideMenuController()!.changeMainViewController(self.home, close: true)
                }
            }else {
                let vc = R.storyboard.kmStoryboard.kmThemeViewController()!
                vc.themeModel = self.vm.themeArr.value.item(at: indexPath.row)
                let nav = KMBaseNavigationController(rootViewController: vc)
                
                self.slideMenuController()!.changeMainViewController(nav, close: true)
            }
        }).disposed(by: rx.disposeBag)
        
        (themeList.rx.willDisplayCell).subscribe(onNext: { (cell, indexPath) in
            if indexPath.row == 0 && self.slideMenuController()!.mainViewController!.isEqual(self.home) && cell.isSelected == false {
                self.themeList.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            }
        }).disposed(by: rx.disposeBag)
    }
    
}

extension KMMenuViewController : UIScrollViewDelegate {
    
}

extension KMMenuViewController : UITableViewDelegate  {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}

