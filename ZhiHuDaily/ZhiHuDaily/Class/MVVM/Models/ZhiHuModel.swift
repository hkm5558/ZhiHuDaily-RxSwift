//
//  ZhiHuModel.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/3.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import ObjectMapper


struct Stories : Mappable {
    
    var date: String?
    var stories : [Story]?
    var top_stories : [Story]?
    
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        date        <- map["date"]
        stories     <- map["stories"]
        top_stories <- map["top_stories"]
    }
}
struct Story : Mappable {
    var images : [String]?
    var image : String?
    var type : Int?
    var id : Int?
    var ga_prefix : String?
    var title : String?
    var multipic = false
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        images          <- map["images"]
        image           <- map["image"]
        type            <- map["type"]
        id              <- map["id"]
        ga_prefix       <- map["ga_prefix"]
        title           <- map["title"]
        multipic        <- map["multipic"]
    }
}


struct StoryDetailModel : Mappable {
    var css : [String]?
    var id : Int?
    var type : Int?
    var images : [String]?
    var ga_prefix : String?
    var js : [String]?
    var share_url : String?
    var image : String?
    var title : String?
    var image_source : String?
    var body : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        css             <- map["css"]
        id              <- map["id"]
        type            <- map["type"]
        images          <- map["images"]
        ga_prefix       <- map["ga_prefix"]
        js              <- map["js"]
        share_url       <- map["share_url"]
        image           <- map["image"]
        title           <- map["title"]
        image_source    <- map["image_source"]
        body            <- map["body"]
    }
    
}

