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
                .filterSuccessfulStatusCodes()
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
                .filterSuccessfulStatusCodes()
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
                .filterSuccessfulStatusCodes()
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
    
    static func fetchThemeList() -> Observable<[ThemeModel]> {
        return Observable.create({ (observer) -> Disposable in
            kmapi
                .rx
                .request(.themeList)
                .filterSuccessfulStatusCodes()
                .subscribe(onSuccess: { (response) in
                    do {
                        let responseModel = try response.mapObject(ThemeResponseModel.self)
                        if let themeArr = responseModel.others {
                            observer.onNext(themeArr)
                        }
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
    
    static func fetchThemeStories(with id : Int) -> Observable<ThemeStoriesModel> {
        return Observable.create({ (observer) -> Disposable in
            kmapi
                .rx
                .request(.themeDesc(id))
                .filterSuccessfulStatusCodes()
                .subscribe(onSuccess: { (response) in
                    do {
                        let themeStoriesModel = try response.mapObject(ThemeStoriesModel.self)
                        observer.onNext(themeStoriesModel)
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
