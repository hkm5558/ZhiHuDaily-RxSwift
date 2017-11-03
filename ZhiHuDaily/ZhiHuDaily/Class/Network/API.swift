//
//  API.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/3.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import Moya

enum API {
    case launchImg
    case newsList
    case moreNews(String)
    case themeList
    case themeDesc(Int)
    case newsDesc(Int)
}
extension API : TargetType {
    var baseURL: URL {
        return URL(string: "http://news-at.zhihu.com/api/")!
    }
    
    var path: String {
        switch self {
        case .launchImg:
            return "7/prefetch-launch-images/750*1142"
        case .newsList:
            return "4/news/latest"
        case .moreNews(let date):
            return "4/news/before/" + date
        case .themeList:
            return "4/themes"
        case .themeDesc(let id):
            return "4/theme/\(id)"
        case .newsDesc(let id):
            return "4/news/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
       return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
}

let kmapi = MoyaProvider<API>()
