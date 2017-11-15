//
//  Response+HandyJSON.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/3.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import HandyJSON

extension Response {
    /// 将json解析为单个的Model
    public func mapObject<T: HandyJSON>(_ type: T.Type) throws -> T {
        guard let dic = try self.mapJSON() as? NSDictionary else {
            throw MoyaError.jsonMapping(self)
        }
        guard let obj = T.deserialize(from: dic) else {
            throw MoyaError.jsonMapping(self)
        }
        return obj
    }
}

extension ObservableType where E == Response {
    /// 这个是将JSON解析为Observable类型的Model
    public func mapObject<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(T.self))
        }
    }
}
