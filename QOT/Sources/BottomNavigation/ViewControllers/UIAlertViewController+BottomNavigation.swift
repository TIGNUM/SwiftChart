//
//  UIAlertViewController+BottomNavigation.swift
//  QOT
//
//  Created by Sanggeon Park on 25.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import SafariServices

extension SFSafariViewController: ScreenZLevelOverlay {

}

extension UIActivityViewController: ScreenZLevelOverlay {

}

extension UIAlertController: ScreenZLevelOverlay {

    private static var _lastBottomNavigationItem = [String: BottomNavigationItem]()

    var lastBottomNavigationItem: BottomNavigationItem? {
        get {
            return UIAlertController._lastBottomNavigationItem[objectAddressString] ?? nil
        }
        set(newValue) {
            UIAlertController._lastBottomNavigationItem[objectAddressString] = newValue
        }
    }

    var objectAddressString: String {
        return String(format: "%p", unsafeBitCast(self, to: Int.self))
    }

    override open func viewWillAppear(_ animated: Bool) {
        lastBottomNavigationItem = baseRootViewController?.currentBottomNavigationItem()
        super.viewWillAppear(animated)
    }

    override open func viewWillDisappear(_ animated: Bool) {
        let notification = Notification(name: .updateBottomNavigation, object: lastBottomNavigationItem, userInfo: nil)
        NotificationCenter.default.post(notification)
        let controllerIdentifier = objectAddressString
        DispatchQueue.main.async {
            UIAlertController._lastBottomNavigationItem[controllerIdentifier] = nil
        }

        super.viewWillDisappear(animated)
    }
    @objc override open func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override open func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}
