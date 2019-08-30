//
//  MFMailComposeViewController+Convenience.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 20.11.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import MessageUI

private struct PageNameMail {
    static var value = PageName.supportContact
}

extension MFMailComposeViewController: ScreenZLevelOverlay {

    var pageType: PageName {
        get {
            return PageNameMail.value
        }
        set {
            PageNameMail.value = newValue
            objc_setAssociatedObject(self,
                                     &PageNameMail.value,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    convenience init(pageName: PageName) {
        self.init()
        self.pageType = pageName
    }
}
