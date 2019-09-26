//
//  BaseViewController.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 24/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isLightBackground() ? .default : .lightContent
    }

    deinit {
        print("DEINIT \(self)")
    }

}
