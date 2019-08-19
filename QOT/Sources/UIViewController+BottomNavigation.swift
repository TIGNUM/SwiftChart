//
//  UIViewController+BottomNavigation.swift
//  QOT
//
//  Created by karmic on 16.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

extension UIViewController {
    func updateBottomNavigation(_ leftBarButtonItems: [UIBarButtonItem], _ rightBarButtonItems: [UIBarButtonItem]) {
        let navigationItem = BottomNavigationItem(leftBarButtonItems: leftBarButtonItems,
                                                  rightBarButtonItems: rightBarButtonItems,
                                                  backgroundColor: .clear)
        NotificationCenter.default.post(name: .updateBottomNavigation, object: navigationItem)
    }
}

// MARK: - UIBarButtonItem
extension UIViewController {
    func cancelButtonItem(_ action: Selector) -> UIBarButtonItem {
        return roundedBarButtonItem(title: R.string.localized.buttonTitleCancel(),
                                    buttonWidth: .Cancel,
                                    action: action,
                                    backgroundColor: .clear,
                                    borderColor: .accent40)
    }

    func continueButtonItem(_ action: Selector) -> UIBarButtonItem {
        return roundedBarButtonItem(title: R.string.localized.profileConfirmationDoneButton(),
                                    buttonWidth: .Continue,
                                    action: action,
                                    backgroundColor: .clear,
                                    borderColor: .accent40)
    }

    func saveButtonItem(_ action: Selector) -> UIBarButtonItem {
        return roundedBarButtonItem(title: R.string.localized.alertButtonTitleSave(),
                                    buttonWidth: .Cancel,
                                    action: action,
                                    backgroundColor: .sand08)
    }
}
