//
//  KMMeunViewModel.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/15.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import NSObject_Rx

class KMMeunViewModel : HasDisposeBag {
    
    let themeArr = Variable([ThemeModel]())
    
    let loadThemeListCommand = PublishSubject<Void>()
    
    
    init() {
        bind()
    }
}
extension KMMeunViewModel {
    func bind() {
        loadThemeListCommand
            .flatMapLatest { _ in Network.fetchThemeList() }
            .subscribe(onNext: { (themeArray) in
                
                var array = [ThemeModel]()
                
                array.append(contentsOf: themeArray)
                var homeThemeModel = ThemeModel()
                homeThemeModel.name = "首页"
            
                array.insert(homeThemeModel, at: 0)

                self.themeArr.value = array
            })
            .disposed(by: disposeBag)
    }
}
