//
//  KMHomeViewModel.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/3.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx
import Action
class KMHomeViewModel : HasDisposeBag {

    
    let loadNewDataCommand = PublishSubject<Void>()
    let loadMoreDaraCommand = PublishSubject<Void>()

    let top_stories = Variable<[Story]>([])
    let stories = Variable([Stories]())
    
    var newsDate = ""
    
    init() {
        bind()
    }
}
extension KMHomeViewModel {
    func bind() {
        loadNewDataCommand
            .flatMapLatest({ _ in Network.fetchTodayNews() })
            .subscribe(onNext: { [unowned self] (storiesModel) in
                if let top_stories = storiesModel.top_stories {
                    self.top_stories.value = top_stories
                }
                if let date = storiesModel.date {
                  self.newsDate = date
                }
                self.stories.value = [storiesModel]
            })
            .disposed(by: disposeBag)

        loadMoreDaraCommand
            .flatMap { [unowned self] in Network.fetchMoreNews(with:self.newsDate) }
            .subscribe(onNext: { [unowned self] (stories) in
                if let date = stories.date {
                    self.newsDate = date
                }
                self.stories.value.append(stories)
            })
            .disposed(by: disposeBag)
    }
}
