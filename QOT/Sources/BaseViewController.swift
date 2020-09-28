//
//  BaseViewController.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 24/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isLightBackground() ? .default : .lightContent
    }

    deinit {
        log("DEINIT 🏁🏁🏁: \(self)", level: .debug)
    }
}
