//
//  WhatsHotBadgeManager.swift
//  QOT
//
//  Created by Lee Arromba on 08/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

/**
 danhaller
 
 1.) Yes, we will keep the dot that is currently shown on the What’s Hot tab.
 2.) The dot should appear under the following conditions:
 
 - New WH article is available
 - WH article was not opened in the WH section
 - The LEARN dot disappears while being in the LEARN section, but will appear again if the user moves to a different section (e.g. ME) without opening the WH article
 - The LEARN dot disappears if a new unread WH article was opened (this is also when the dot on the WH tab disappears)
 */

final class WhatsHotBadgeManager {

    private weak var whatsHotBadge: Badge?
    weak var tabBarController: TabBarController?
    weak var whatsHotButton: UIButton?

    var isShowingLearnTab: Bool = false {
        didSet {
            update()
        }
    }

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChangeNotification),
                                               name: UserDefaults.didChangeNotification,
                                               object: nil)
    }
}

// MARK: - Private

private extension WhatsHotBadgeManager {

    func update() {
        whatsHotBadge?.removeFromSuperview()
        tabBarController?.mark(isRead: true, at: 1)
        guard UserDefault.newWhatsHotArticle.boolValue == true else { return }

        // @warning - the dot is supposed to be on the top right of the text, not the button. as such, these magic numbers represent a fraction of the button size to position the dot artificially close to the text. percentages keep the effect similar on different device sizes. however with changing texts (e.g. uk / german) the dots will 'seem' in the wrong place as the text will be too close to the dot etc. this should be improved later.
        if isShowingLearnTab == true {
            let topOffset = (whatsHotButton?.bounds.height ?? 0) * 0.1
            let rightOffset = (whatsHotButton?.bounds.width ?? 0) * 0.08
            whatsHotBadge = whatsHotButton?.addBadge(topAnchorOffset: topOffset, rightAnchorOffset: rightOffset)
        } else {
            tabBarController?.mark(isRead: false, at: 1)
        }
    }

    // MARK: - notifications

    @objc func userDefaultsDidChangeNotification(_ noticiation: Notification) {
        DispatchQueue.main.async {
            self.update()
        }
    }
}
