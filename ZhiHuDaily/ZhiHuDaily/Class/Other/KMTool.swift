//
//  KMTool.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/7.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import UIKit

struct Tool {
    static func homeSectionHeaderString(with dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        if let date = dateFormatter.date(from: dateString) {
            let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
            dateFormatter.timeZone = timeZone
            dateFormatter.locale = Locale.init(identifier: "zh")
            dateFormatter.dateFormat = "MM月dd日 EEEE"
            return dateFormatter.string(from: date)
        }
        return dateString
    }
}
