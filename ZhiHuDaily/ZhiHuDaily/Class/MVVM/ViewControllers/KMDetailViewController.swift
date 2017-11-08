//
//  KMDetailViewController.swift
//  ZhiHuDaily
//
//  Created by KM on 2017/11/8.
//  Copyright © 2017年 KM. All rights reserved.
//

import UIKit

class KMDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.FlatUI.greenSea
        avoidAutomaticDown64()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.slideMenuController()?.addLeftGestures()
    }

}
