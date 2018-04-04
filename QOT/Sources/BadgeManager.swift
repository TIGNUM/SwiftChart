//
//  BadgeManager.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 22/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

enum TabBar: Int {

    case guide = 0
    case learn = 1
    case me = 2
    case prepare = 3
}

final class BadgeManager {
    weak var tabBarController: TabBarController?

    var tabDisplayed: TabBar = .guide {
        didSet {
            update()
        }
    }

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChangeNotification),
                                               name: UserDefaults.didChangeNotification,
                                               object: nil)
    }

    private func update() {
        checkIfNewItemWasAdded()
        hideCurrentTabBadge()
    }

    func hideCurrentTabBadge() {
        switch tabDisplayed {
        case .guide:
            tabBarController?.mark(isRead: true, at: tabDisplayed.rawValue)
        case .learn:
            tabBarController?.mark(isRead: true, at: tabDisplayed.rawValue)
        case .me, .prepare: return
        }
    }

    func checkIfNewItemWasAdded() {
        if UserDefault.newGuideItem.boolValue == true {
            tabBarController?.mark(isRead: false, at: 0)
        }
    }

    @objc func userDefaultsDidChangeNotification(_ noticiation: Notification) {
        DispatchQueue.main.async {
            self.update()
        }
    }
}
