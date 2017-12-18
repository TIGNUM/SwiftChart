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
    private var days: [Guide.Day] = []

    init(services: Services, eventTracker: EventTracker) {
        self.services = services
        self.eventTracker = eventTracker
        createTodaysGuideIfNeeded()
        reload()
    }

    private func reload() {
        days = services.guideService.guideSections().map { Guide.Day(day: $0) }
    }

    var sectionCount: Int {
        return days.count
    }

    func numberOfRows(section: Int) -> Int {
        return days[section].items.count
    }

    func item(indexPath: IndexPath) -> Guide.Item {
        return days[indexPath.section].items[indexPath.row]
    }

//    func guide(section: Int) -> Guide {
//        return services.guideService.guideSections()[section]
//    }


    func createTodaysGuideIfNeeded() {
        guard services.guideService.todaysGuide() == nil else { return }

        _ = GuideWorker(services: services).createTodaysGuide()
    }

    func dailyPrepItem() -> RealmGuideItem? {
        return nil
//        let predicate = NSPredicate(format: "type == %@", GuideItemNotification.ItemType.morningInterview.rawValue)
//        return todaysGudie?.items.filter(predicate).first
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

//    func updateGuideItems(_ items: List<GuideItem>, guide: Guide) throws {
//        let realm = services.mainRealm
//        try realm.write {
//            guide.items = items
//        }
//    }
}

private extension Guide.Day {

    init(day: RealmGuide) {
        items = Array(day.items).flatMap { Guide.Item(item: $0) }
    }
}

private extension Guide.Item {

    init?(item: RealmGuideItem) {
        if let learn = item.guideItemLearn {
            status = learn.completedAt == nil ? .todo : .done
            title = learn.title
            content = .text(learn.body)
            subtitle = learn.type
        } else if let notification = item.guideItemNotification {
            status = notification.completed == false ? .todo : .done
            title = notification.title ?? ""
            content = .text(notification.body)
            subtitle = notification.type
        } else {
            return nil
        }
    }
}
