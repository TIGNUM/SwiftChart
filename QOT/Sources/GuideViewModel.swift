//
//  GuideViewModel.swift
//  QOT
//
//  Created by karmic on 29.11.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift
import UIKit

extension GuideViewModel {

    enum Status {
        case todo
        case done

        var cardColor: UIColor {
            switch self {
            case .done: return .whiteLight6
            case .todo: return .whiteLight12
            }
        }

        var statusViewColor: UIColor {
            switch self {
            case .done: return .charcoalGreyMedium
            case .todo: return .white
            }
        }
    }
}

extension GuideViewModel {

    enum GuideType {
        case newFeature
        case featureExplainer
        case tignumExplainer
        case morningInterview
        case strategy
        case notification

        var title: String {
            switch self {
            case .newFeature: return "New Feature"
            case .featureExplainer: return "Feature Explainer"
            case .tignumExplainer: return "Tignum System"
            case .morningInterview: return "Morning Interview"
            case .strategy: return "55 Strategies"
            case .notification: return "Notification"
            }
        }
    }
}

final class GuideViewModel {

    private let services: Services
    private let eventTracker: EventTracker

    init(services: Services, eventTracker: EventTracker) {
        self.services = services
        self.eventTracker = eventTracker
    }

    var sectionCount: Int {
        return services.guidePlanService.plans().count
    }

    func numberOfRows(section: Int) -> Int {
        let learnRows = services.guidePlanService.learnItems(section: section).count
        let notificationRows = services.guidePlanService.notificationItems(section: section).count

        return learnRows + notificationRows
    }

    func plan(section: Int) -> GuidePlan {
        return services.guidePlanService.plans()[section]
    }
}
