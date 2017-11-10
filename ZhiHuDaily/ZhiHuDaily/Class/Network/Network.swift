//
//  Network.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/3.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

let bag = DisposeBag()


//func fetchLaunchImg() -> Observable<Stories> {
//
//}



struct Network {
    static func fetchTodayNews() -> Observable<Stories> {
        return Observable.create({ (observer) -> Disposable in
            kmapi
                .rx
                .request(.newsList)
                .subscribe(onSuccess: { (response) in
                    do {
                        let stories = try response.mapObject(Stories.self)
                        observer.onNext(stories)
                        observer.onCompleted()
                    }catch{
                        Toast.show(with: "格式解析失败")
                        observer.onError(error)
                    }
            }, onError: { (error) in
                observer.onError(error)
            }).disposed(by: bag)
            
            return Disposables.create()
        })
    }
    
    static func fetchNewsDetail(_ newId : Int) -> Observable<StoryDetailModel> {
        return Observable.create({ (observer) -> Disposable in
            kmapi
                .rx
                .request(.newsDesc(newId))
                .subscribe(onSuccess: { (response) in
                    do {
                        let detail = try response.mapObject(StoryDetailModel.self)
                        observer.onNext(detail)
                        observer.onCompleted()
                    }catch{
                        Toast.show(with: "格式解析失败")
                        observer.onError(error)
                    }
                }, onError: { (error) in
                    observer.onError(error)
                })
        })
    }
    
    static func fetchMoreNews(with date : String) -> Observable<Stories> {
        return Observable.create({ (observer) -> Disposable in
            
            kmapi
                .rx
                .request(.moreNews(date))
                .subscribe(onSuccess: { (response) in
                    do {
                        let stories = try response.mapObject(Stories.self)
                        observer.onNext(stories)
                        observer.onCompleted()
                    }catch{
                        Toast.show(with: "格式解析失败")
                        observer.onError(error)
                    }
                }, onError: { (error) in
                    observer.onError(error)
                })
                .disposed(by: bag)
            
            return Disposables.create()
        })
    }
    
}
