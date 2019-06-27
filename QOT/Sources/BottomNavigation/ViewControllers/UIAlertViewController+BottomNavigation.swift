//
//  UIAlertViewController+BottomNavigation.swift
//  QOT
//
//  Created by Sanggeon Park on 25.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

extension UIAlertController: ScreenZLevel {
    @objc override open func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override open func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}
