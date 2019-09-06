//
//  UIViewController+BottomNavigation.swift
//  QOT
//
//  Created by karmic on 16.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

extension UIViewController {
    func updateBottomNavigation(_ leftBarButtonItems: [UIBarButtonItem], _ rightBarButtonItems: [UIBarButtonItem]) {
        DispatchQueue.main.async {
            let navigationItem = BottomNavigationItem(leftBarButtonItems: leftBarButtonItems,
                                                      rightBarButtonItems: rightBarButtonItems,
                                                      backgroundColor: .clear)
            NotificationCenter.default.post(name: .updateBottomNavigation, object: navigationItem)
        }
    }
}

// MARK: - UIBarButtonItem
extension UIViewController {
    func cancelButtonItem(_ action: Selector) -> UIBarButtonItem {
        return roundedBarButtonItem(title: ScreenTitleService.main.localizedString(for: .ButtonTitleCancel),
                                    buttonWidth: .Cancel,
                                    action: action,
                                    backgroundColor: .clear,
                                    borderColor: .accent40)
    }

    func continueButtonItem(_ action: Selector) -> UIBarButtonItem {
        return roundedBarButtonItem(title: R.string.localized.buttonTitleYesLeave(),
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

    func saveChangesButtonItem(_ action: Selector) -> UIBarButtonItem {
        return roundedBarButtonItem(title: R.string.localized.buttonTitleSaveChanges(),
                                    buttonWidth: .SaveChanges,
                                    action: action,
                                    borderColor: .accent40)
    }
}
