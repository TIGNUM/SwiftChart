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
        pageTrack.pageId = pageID
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
    }

    func trackUserEvent(_ name: UserEventName,
                        value: Int? = nil,
                        valueType: UserEventValueType? = nil,
                        action: UserEventAction) {
        var userEventTrack = QDMUserEventTracking()
        userEventTrack.name = name
        userEventTrack.value = value
        userEventTrack.valueType = valueType
        userEventTrack.action = action
        NotificationCenter.default.post(name: .reportUserEvent, object: userEventTrack)
    }
}

// MARK: - IDs

private extension UIViewController {
    var pageID: Int {
        switch self {
        case is DecisionTreeViewController: return decisionTreePageID
        case is MindsetShifterChecklistViewController: return 0
        default: preconditionFailure()
        }
    }
}

// MARK: - DecisionTree IDs

private extension UIViewController {
    var decisionTreePageID: Int {
        switch (self as? DecisionTreeViewController)?.interactor?.type {
        case .toBeVisionGenerator?: return 0
        case .mindsetShifter?: return 1
        case .mindsetShifterTBV?: return 2
        case .prepare?: return 3
        default: preconditionFailure("DecisionTree page ID missing")
        }
    }
}
