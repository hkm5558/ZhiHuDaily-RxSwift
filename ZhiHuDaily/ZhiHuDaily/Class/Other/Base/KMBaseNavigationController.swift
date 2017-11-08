//
//  KMBaseNavigationController.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/8.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit

class KMBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactivePopGestureRecognizer?.isEnabled = true
    }
    deinit {
        interactivePopGestureRecognizer?.delegate = nil
    }
}

//MARK: - -----  UIGestureRecognizerDelegate -----
extension KMBaseNavigationController : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count <= 1 && gestureRecognizer.isEqual(interactivePopGestureRecognizer) {
            return false
        }
        return true
    }
    // 允许同时响应多个手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    // 禁止响应手势 是否和ViewController中scrollView跟着滚动
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
