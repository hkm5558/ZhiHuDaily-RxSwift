//
//  ZhiHuModel.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/3.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import HandyJSON


struct Stories : HandyJSON {
    
    var date: String?
    var stories : [Story]?
    var top_stories : [Story]?
}
struct Story : HandyJSON {
    var images : [String]?
    var image : String?
    var type : Int?
    var id : Int?
    var ga_prefix : String?
    var title : String?
    var multipic = false
}


struct StoryDetailModel : HandyJSON {
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
}

struct ThemeResponseModel : HandyJSON {
    var others : [ThemeModel]?
}

struct ThemeModel : HandyJSON {
    var color : Int?
    var thumbnail : String?
    var description : String?
    var id : Int?
    var name : String?
}

