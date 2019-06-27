//
//  AbstractLevelThreeViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class AbstractLevelThreeViewController: UIViewController, ScreenZLevel3 {

    @objc override open func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return [dismissNavigationItem()]
    }
}
