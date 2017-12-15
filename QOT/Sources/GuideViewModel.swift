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
    private let guideBlocks = [Guide]()
    private let guideOfToday: Guide

    init(services: Services, eventTracker: EventTracker) {
        self.services = services
        self.eventTracker = eventTracker

        func guideOfToday() -> Guide {
            let learnItems = services.guideItemLearnService.items()
            let notificationItems = services.guideItemNotificationService.todayItems()

            return Guide(learnItems: learnItems, notificationItems: notificationItems)
        }

        self.guideOfToday = guideOfToday()
        do {
            try saveGuideToday()
        } catch {
            assertionFailure("Failed to save Guide Plan for today with error: \(error)")
        }
    }

    var sectionCount: Int {
        return services.guideService.guideSections().count
    }

    func numberOfRows(section: Int) -> Int {
        return guideOfToday.items.count
    }

    func guide(section: Int) -> Guide {
        return services.guideService.guideSections()[section]
    }

    func guideItem(indexPath: IndexPath) -> GuideItem {
        return guideOfToday.items[indexPath.row]
    }

    func dailyPrepItem() -> GuideItem? {
        let predicate = NSPredicate(format: "type == %@", GuideItemNotification.ItemType.morningInterview.rawValue)
        return guideOfToday.items.filter(predicate).first
//
//        return GuideItemNotification.DailyPrepItem(feedback: dailyPrep.feedback,
//                                                       results: Array(dailyPrep.dailyPrepResults.map { $0.value }),
//                                                       link: dailyPrep.link,
//                                                       title: dailyPrep.title,
//                                                       body: dailyPrep.body,
//                                                       greeting: dailyPrep.greeting,
//                                                       issueDate: dailyPrep.issueDate,
//                                                       status: dailyPrep.completed == true ? .done : .todo)
    }

    func saveGuideToday() throws {
        let realm = services.mainRealm
        try realm.write {
            realm.add(guideOfToday)
        }
    }
}
