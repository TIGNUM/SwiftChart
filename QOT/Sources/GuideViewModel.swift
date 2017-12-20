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
            featureLink = learn.featureLink.isEmpty == true ? nil : .path(learn.featureLink)
            identifier = item.localID
            dailyPrep = nil
            greeting = learn.greeting
            createdAt = learn.createdAt
        } else if let notification = item.guideItemNotification {
            status = notification.completedAt == nil ? .todo : .done
            title = notification.title ?? ""
            content = .text(notification.body)
            subtitle = notification.displayType
            type = notification.type
            link = .path(notification.link)
            featureLink = nil
            identifier = item.localID
            dailyPrep = DailyPrep(feedback: notification.morningInterviewFeedback,
                                  results: Array(notification.dailyPrepResults.map { String(format: "%d", $0.value) }))
            greeting = notification.greeting
            createdAt = notification.createdAt
        } else {
            return nil
        }
    }
}

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
    private let syncStateObserver: SyncStateObserver
    private var notificationTokenHandler: NotificationTokenHandler?
    private var tokenBin = TokenBin()
    let updates = PublishSubject<CollectionUpdate, NoError>()
    let sectionCountUpdate = ReplayOneSubject<Int, NoError>()
    private var days: [Guide.Day] = [] {
        didSet {
            updates.next(.reload)
        }
    }

    init(services: Services, eventTracker: EventTracker) {
        self.services = services
        self.eventTracker = eventTracker
        syncStateObserver = SyncStateObserver(realm: services.mainRealm)
        syncStateObserver.observe(\.syncedClasses, options: [.new]) { [unowned self] _, _ in
            self.createTodaysGuideIfNeeded()
            self.reload()
            self.updates.next(.reload)
        }.addTo(tokenBin)
    }

    private func reload() {
        days = services.guideService.guideSections().map { Guide.Day(day: $0) }

        sectionCountUpdate.next(sectionCount)
    }

    var isReady: Bool {
        return syncStateObserver.hasSynced(RealmGuideItemLearn.self) && syncStateObserver.hasSynced(RealmGuideItemNotification.self)
    }

    var sectionCount: Int {
        return days.count
    }

    func greeting() -> String? {
        return days.last?.items.filter { $0.status == .todo }.map { $0.greeting }.first ?? ""
    }

    func message() -> String {
        let userName = services.mainRealm.objects(User.self).first?.givenName ?? ""
        let welcomeMessage = Date().isBeforeNoon == true ? "Good Morning" : "Hello"
        return String(format: "%@ %@\n", welcomeMessage, userName)
    }

    func numberOfRows(section: Int) -> Int {
        return days[section].items.count
    }

    func header(section: Int) -> Date {
        return services.guideService.guideSections()[section].createdAt
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
        let todaysGuide = services.guideService.todaysGuide()
        guard todaysGuide?.items.isEmpty == true || todaysGuide == nil else { return }
        services.guideService.eraseGuide()
        _ = GuideWorker(services: services).createTodaysGuide()
    }
}
