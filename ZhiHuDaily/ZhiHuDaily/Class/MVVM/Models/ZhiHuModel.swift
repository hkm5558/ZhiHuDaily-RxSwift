//
//  ZhiHuModel.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/3.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

struct Stories : Mappable {
    
    var date: String?
    var stories : [Story]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        date        <- map["date"]
        stories     <- map["stories"]
    }
}
struct Story : Mappable {
    var images : [String]?
    var type : Int?
    var id : Int?
    var ga_prefix : String?
    var title : String?
    
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        images          <- map["images"]
        type            <- map["type"]
        id              <- map["id"]
        ga_prefix       <- map["ga_prefix"]
        title           <- map["title"]
    }
}

struct HomeSection {
    var items : [Item]
}
extension HomeSection : SectionModelType {
    typealias Item = Story

    init(original: HomeSection, items: [HomeSection.Item]) {
        self = original
        self.items = items
    }
}
