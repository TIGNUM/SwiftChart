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

    func removeBottomNavigation() {
        let item = BottomNavigationItem(leftBarButtonItems: [], rightBarButtonItems: [], backgroundColor: .clear)
        NotificationCenter.default.post(name: .updateBottomNavigation, object: item)
    }
}

// MARK: - UIBarButtonItem
extension UIViewController {
    ///TODO: Generelise button creation, enum with types.
    func doneButtonItem(_ action: Selector, borderColor: UIColor? = nil) -> UIBarButtonItem {
        return roundedBarButtonItem(title: AppTextService.get(AppTextKey.generic_view_button_done),
                                    buttonWidth: .Done,
                                    action: action,
                                    backgroundColor: .carbon,
                                    borderColor: borderColor ?? .clear)
    }

    func cancelButtonItem(_ action: Selector) -> UIBarButtonItem {
        return roundedBarButtonItem(title: AppTextService.get(AppTextKey.generic_view_button_cancel),
                                    buttonWidth: .Cancel,
                                    action: action,
                                    backgroundColor: .clear,
                                    borderColor: .accent40)
    }

    func continueButtonItem(_ action: Selector) -> UIBarButtonItem {
        return roundedBarButtonItem(title: AppTextService.get(AppTextKey.my_qot_my_plans_alert_delete_button_continue),
                                    buttonWidth: .Continue,
                                    action: action,
                                    backgroundColor: .clear,
                                    borderColor: .accent40)
    }

    func saveButtonItem(_ action: Selector) -> UIBarButtonItem {
        return roundedBarButtonItem(title: AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_edit_button_save),
                                    buttonWidth: .Cancel,
                                    action: action,
                                    backgroundColor: .sand08)
    }

    func saveChangesButtonItem(_ action: Selector) -> UIBarButtonItem {
        return roundedBarButtonItem(title: AppTextService.get(AppTextKey.my_qot_my_plans_edit_button_delete),
                                    buttonWidth: .SaveChanges,
                                    action: action,
                                    borderColor: .accent40)
    }
}
