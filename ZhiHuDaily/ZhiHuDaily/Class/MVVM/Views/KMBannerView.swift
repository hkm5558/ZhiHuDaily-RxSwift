//
//  KMBannerView.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/4.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx
import Kingfisher




class KMBannerView: UICollectionView {

    
    let top_stories = Variable([Story]())
    let offsetY = Variable(0.0)
    
    weak var bannerDelegate : BannerDelegate?
    
    override func awakeFromNib() {
        let layout = UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: KScreenW, height: 200)
        }
        setCollectionViewLayout(layout, animated: false)
        contentOffset.x = KScreenW
        top_stories
            .asObservable()
            .bind(to: self.rx.items(cellIdentifier: "KMBannerCell", cellType: KMBannerCell.self)){
                row, model, cell in
                cell.imageView.kf.setImage(with: URL.init(string: model.image!), placeholder: R.image.field_Mask_Bg())
                cell.titleLabel.text = model.title
            }.disposed(by: rx.disposeBag)
        rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        offsetY
            .asObservable()
            .subscribe(onNext: { (y) in
                self.visibleCells.forEach({ (cell) in
                    let cell = cell as! KMBannerCell
                    cell.imageTop.constant = y.cgFloat <= 0 ? y.cgFloat : 0
                    cell.imageView.frame.size.height = y.cgFloat <= 0 ? 200 - y.cgFloat : 200
                })
            })
            .disposed(by: rx.disposeBag)
        
        self
            .rx
            .modelSelected(Story.self)
            .subscribe(onNext: { (model) in
                self.bannerDelegate?.selectedItem(model: model)
            })
            .disposed(by: rx.disposeBag)
    }
}



extension KMBannerView : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == (top_stories.value.count - 1).cgFloat * KScreenW {
            scrollView.contentOffset.x = KScreenW
        }else if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset.x = (top_stories.value.count - 2).cgFloat * KScreenW
        }
        bannerDelegate?.scrollTo(index: Int(scrollView.contentOffset.x / KScreenW ) - 1)
    }
}
