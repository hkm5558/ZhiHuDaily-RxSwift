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
import NSObject_Rx
import Kingfisher




class KMBannerView: UICollectionView {

    
    let top_stories = Variable([Story]())
    let offsetY = Variable(CGFloat.init(0))
    
    weak var bannerDelegate : BannerDelegate?
    
    override func awakeFromNib() {
        let layout = UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: KScreenW, height: Config.topStoryViewHeight)
            $0.scrollDirection = .horizontal
            $0.minimumInteritemSpacing = 0.0
            $0.minimumLineSpacing = 0.0
        }
        setCollectionViewLayout(layout, animated: true)
//        layoutIfNeeded()
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
            .asDriver()
            .drive(onNext: { (y) in
            self.visibleCells.forEach({ (cell) in
                let cell = cell as! KMBannerCell
                cell.imageTop.constant = y <= 0 ? y : 0
                cell.imageView.frame.size.height = y <= 0 ? Config.topStoryViewHeight - y : Config.topStoryViewHeight
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
        log.debug("\(scrollView.contentOffset.x)")
        let index = Int(scrollView.contentOffset.x / KScreenW ) - 1
        bannerDelegate?.scrollTo(index: index)
    }
}
