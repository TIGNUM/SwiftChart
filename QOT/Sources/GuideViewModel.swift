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

    func greeting(indexPath: IndexPath) -> String? {
        return item(indexPath: indexPath).greeting
    }

    func numberOfRows(section: Int) -> Int {
        return days[section].items.count
    }

    func item(indexPath: IndexPath) -> Guide.Item {
        return days[indexPath.section].items[indexPath.row]
    }

    func setCompleted(item: Guide.Item, completion: @escaping () -> Void) {
        guard item.status == .todo else { return }

        GuideWorker(services: services).setItemCompleted(guideID: item.identifier) { (error) in
            guard error == nil else { return }

            self.reload()
            completion()
        }
    }

    func cancelPendingNotificationIfNeeded(item: Guide.Item) {
        LocalNotificationBuilder.cancelNotification(identifier: item.identifier)
    }

    func createTodaysGuideIfNeeded() {
        guard services.guideService.todaysGuide() == nil else { return }

        _ = GuideWorker(services: services).createTodaysGuide()
    }
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
            subtitle = learn.displayType
            type = learn.type
            link = .path(learn.link)
            identifier = item.localID
            dailyPrep = nil
            greeting = learn.greeting
        } else if let notification = item.guideItemNotification {
            status = notification.completedAt == nil ? .todo : .done
            title = notification.title ?? ""
            content = .text(notification.body)
            subtitle = notification.displayType
            type = notification.type
            link = .path(notification.link)
            identifier = item.localID
            dailyPrep = DailyPrep(feedback: notification.morningInterviewFeedback,
                                  results: Array(notification.morningInterviewResults.map { $0.value }))
            greeting = notification.greeting
        } else {
            return nil
        }
    }
}
