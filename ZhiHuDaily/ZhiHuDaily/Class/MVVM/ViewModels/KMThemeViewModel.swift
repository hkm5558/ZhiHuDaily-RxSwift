//
//  KMThemeViewModel.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/16.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
class KMThemeViewModel : HasDisposeBag {

    let themeId = Variable(0)
    
    let stories = Variable(ThemeStoriesModel())
    
    let a = Variable([Story]())
    
    init() {
        bind()
    }
    
}
extension KMThemeViewModel {
    func bind() {
        themeId
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .flatMapLatest({ id in Network.fetchThemeStories(with: id) })
            .bind(to: stories)
            .disposed(by: disposeBag)
    }
}
