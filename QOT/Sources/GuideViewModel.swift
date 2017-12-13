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
    private let guidePlanToday: GuidePlan

    init(services: Services, eventTracker: EventTracker) {
        self.services = services
        self.eventTracker = eventTracker

        func createPlanForToday() -> GuidePlan {
            let learnItems = services.guidePlanItemLearnService.todayItems()
            let notificationItems = services.guidePlanItemNotificationService.todayItems()

            return GuidePlan(learnItems: learnItems, notificationItems: notificationItems)
        }

        self.guidePlanToday = createPlanForToday()
        do {
            try saveGuidePlanToday()
        } catch {
            assertionFailure("Failed to save Guide Plan for today with error: \(error)")
        }
    }

    var sectionCount: Int {
        return services.guidePlanService.plans().count
    }

    func numberOfRows(section: Int) -> Int {
        return guidePlanToday.planItems.count
    }

    func plan(section: Int) -> GuidePlan {
        return services.guidePlanService.plans()[section]
    }

    func planItem(indexPath: IndexPath) -> GuidePlan.PlanItem {
        return guidePlanToday.planItems[indexPath.row]
    }

    func dailyPrepItem() -> GuidePlanItemNotification.DailyPrepItem? {
        let predicate = NSPredicate(format: "type == %@", GuidePlanItemNotification.ItemType.morningInterview.rawValue)
        guard let dailyPrep = guidePlanToday.notificationItems.filter(predicate).first else { return nil }

        return GuidePlanItemNotification.DailyPrepItem(feedback: dailyPrep.morningInterviewFeedback,
                                                       results: Array(dailyPrep.morningInterviewResults.map { $0.value }),
                                                       link: dailyPrep.link,
                                                       title: dailyPrep.title,
                                                       body: dailyPrep.body,
                                                       greeting: dailyPrep.greeting,
                                                       issueDate: dailyPrep.issueDate,
                                                       reminderTime: dailyPrep.reminderTime,
                                                       status: dailyPrep.completed == true ? .done : .todo)
    }

    func saveGuidePlanToday() throws {
        let realm = services.mainRealm
        try realm.write {
            realm.add(guidePlanToday)
        }
    }
}
