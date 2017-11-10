//
//  KMProtocol.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/9.
//  Copyright © 2017年 KM. All rights reserved.
//

import Foundation
import UIKit

public protocol KunminCompatible {
    associatedtype CompatableType
    var km : CompatableType { get }
}
public extension KunminCompatible {
    // 指定泛型类型为自身 ， 自身是协议 谁实现了此协议就是谁了
    public var km : Kunmin<Self> {
        get { return Kunmin(self) }
    }
}
// Auto是一个接受一个泛型类型的结构体
public final class Kunmin<Base> {
    // 定义该泛型类型属性
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

extension UIView : KunminCompatible {}
//extension UINavigationBar : KunminCompatible {}

