//
//  UIAlertViewController+BottomNavigation.swift
//  QOT
//
//  Created by Sanggeon Park on 25.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import SafariServices
import RSKImageCropper
import Social
import MessageUI
import qot_dal
import EventKitUI

extension UIViewController {
    static var _lastBottomNavigationItem = [String: BottomNavigationItem]()
    var objectAddressString: String {
        return String(format: "%p", unsafeBitCast(self, to: Int.self))
    }

    var lastBottomNavigationItem: BottomNavigationItem? {
        get {
            return UIActivityViewController._lastBottomNavigationItem[objectAddressString] ?? nil
        }
        set(newValue) {
            UIActivityViewController._lastBottomNavigationItem[objectAddressString] = newValue
        }
    }

    func cacheCurrentBottomNavigationItems() {
        if lastBottomNavigationItem == nil {
            lastBottomNavigationItem = baseRootViewController?.currentBottomNavigationItem()
        }
    }

    func setBackCachedBottomNavigationItems() {
        let controllerIdentifier = self.objectAddressString
        let notificationObject = lastBottomNavigationItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) { [weak self] in
            if let strongself = self {
                log("\(strongself.self) is still on screen", level: .info)
                return
            }
            let notification = Notification(name: .updateBottomNavigation, object: notificationObject, userInfo: nil)
            NotificationCenter.default.post(notification)
            UIActivityViewController._lastBottomNavigationItem[controllerIdentifier] = nil
        }
    }
}

extension EKEventEditViewController: ScreenZLevelOverlay {

}

extension SFSafariViewController: ScreenZLevelOverlay {

}

extension MFMailComposeViewController: ScreenZLevelOverlay {

    override open func viewWillAppear(_ animated: Bool) {
        cacheCurrentBottomNavigationItems()
        super.viewWillAppear(animated)
    }

    override open func viewDidDisappear(_ animated: Bool) {
        setBackCachedBottomNavigationItems()
        super.viewDidDisappear(animated)
    }

    @objc override open func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override open func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}

extension SLComposeViewController: ScreenZLevelOverlay {
    override open func viewWillAppear(_ animated: Bool) {
        cacheCurrentBottomNavigationItems()
        super.viewWillAppear(animated)
    }

    override open func viewDidDisappear(_ animated: Bool) {
        setBackCachedBottomNavigationItems()
        super.viewDidDisappear(animated)
    }

    @objc override open func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override open func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}

extension UIActivityViewController: ScreenZLevelOverlay {
    override open func viewWillAppear(_ animated: Bool) {
        cacheCurrentBottomNavigationItems()
        super.viewWillAppear(animated)
    }

    override open func viewDidDisappear(_ animated: Bool) {
        setBackCachedBottomNavigationItems()
        super.viewDidDisappear(animated)
    }

    @objc override open func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override open func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}

extension UIImagePickerController: ScreenZLevelOverlay {

}

extension RSKImageCropViewController: ScreenZLevelOverlay {

}

extension UIAlertController: ScreenZLevelOverlay {
    override open func viewWillAppear(_ animated: Bool) {
        cacheCurrentBottomNavigationItems()
        super.viewWillAppear(animated)
    }

    override open func viewDidDisappear(_ animated: Bool) {
        setBackCachedBottomNavigationItems()
        super.viewDidDisappear(animated)
    }

    @objc override open func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override open func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}
