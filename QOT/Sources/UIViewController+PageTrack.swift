//
//  UIViewController+PageTrack.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 29.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

// MARK: - Actions

extension UIViewController {
    func trackPage() {
        var pageTrack = QDMPageTracking()
        pageTrack.pageId = 100013
        pageTrack.pageKey = pageKey
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
    }
    
    func trackUserEvent(_ name: UserEventName,
                        value: Int? = nil,
                        valueType: String? = nil,
                        action: UserEventAction) {
        var userEventTrack = QDMUserEventTracking()
        userEventTrack.name = name
        userEventTrack.value = value
        userEventTrack.valueType = valueType
        userEventTrack.action = action
        NotificationCenter.default.post(name: .reportUserEvent, object: userEventTrack)
    }
}

// MARK: - Keys

private extension UIViewController {
    var pageKey: String {
        switch self {
        case is DecisionTreeViewController: return decisionTreePageKey
        case is MindsetShifterChecklistViewController: return "0"
        case is MyQotProfileViewController: return "myprofile.home"
        case is MyQotAccountSettingsViewController: return "myprofile.accountsettings"
        case is ProfileSettingsViewController: return "myprofile.accountsettings.edit"
        case is MyQotAppSettingsViewController: return "myprofile.appsettings"
        case is MyQotAboutUsViewController: return "myprofile.aboutus"
        case is MyQotSupportViewController: return "myprofile.support"
        case is MyQotSyncedCalendarsViewController: return "myprofile.appsettings.syncedcalendars"
        case is MyQotSensorsViewController: return "myprofile.appsettings.activitytrackers"
        case is MyQotSiriShortcutsViewController: return "myprofile.appsettings.sirishortcuts"
        case is MyQotSupportFaqViewController: return "myprofile.support.faq"
        case is TutorialViewController: return "myprofile.support.tutorial"
        default: preconditionFailure()
        }
    }
}

// MARK: - DecisionTree IDs

private extension UIViewController {
    var decisionTreePageKey: String {
        switch (self as? DecisionTreeViewController)?.interactor?.type {
        case .toBeVisionGenerator?: return "0"
        case .mindsetShifter?: return "1"
        case .mindsetShifterTBV?: return "2"
        case .prepare?: return "3"
        default: preconditionFailure("DecisionTree page ID missing")
        }
    }
}
