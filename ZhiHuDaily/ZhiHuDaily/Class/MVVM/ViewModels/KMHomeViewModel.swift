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
class KMHomeViewModel : ViewModelProtocol {

    
    typealias Input = HomeInput
    
    typealias Output = HomeOutput
    
    struct HomeInput {
        let date = Variable<String>("")
    }
    
    struct HomeOutput {
        let loadNewDataCommand = PublishSubject<Void>()
        
        let section: Driver<[HomeSection]>
        init(homeSection: Driver<[HomeSection]>) {
            section = homeSection
        }
    }
    
    func transform(input: KMHomeViewModel.HomeInput) -> KMHomeViewModel.HomeOutput {
        
        let section = _stories.asObservable().map { (stories) -> [HomeSection] in
            return [HomeSection(items: stories)]
        }.asDriver(onErrorJustReturn: [])
        
        let output = Output(homeSection: section)
        
        return output
    }
    
    
    fileprivate let _stories = Variable<[Story]>([])
    
    init() {
        
    }
}
