//
//  KMDetailViewModel.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/10.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import NSObject_Rx
class KMDetailViewModel : HasDisposeBag {
    
    var newsDetail : Observable<StoryDetailModel>
    
    var newsId : Variable<Int>
    
    init() {
        newsId = Variable(0)
        newsDetail = newsId.asObservable().filter({
            $0 != 0
        }).flatMapLatest({ (id) in
            return Network.fetchNewsDetail(id)
        })
    }
}
