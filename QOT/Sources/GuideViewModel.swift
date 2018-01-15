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

    enum Greeting: Int {
        case welcome = 102978
        case dailyLearnPlan = 102979
        case dailyPrep = 103002
        case guideAllCompleted = 103108
        case guideTodayCompleted = 103107

        func text(_ contentService: ContentService) -> String {
            return contentService.defaultMessage(self.rawValue)
        }
    }
}

final class GuideViewModel {

    private let services: Services
    private let eventTracker: EventTracker
    private let syncStateObserver: SyncStateObserver
    private let realmGuides: AnyRealmCollection<RealmGuide>
    private var notificationTokenHandler: NotificationTokenHandler?
    private var tokenBin = TokenBin()
    private let becomeActiveHandler = NotificationHandler(name: .UIApplicationDidBecomeActive)
    private let guideWorker: GuideWorker
    let updates = PublishSubject<CollectionUpdate, NoError>()
    let sectionCountUpdate = ReplayOneSubject<Int, NoError>()
    private var days: [Guide.Day] = []

    private lazy var welcome: String = {
        return Greeting.welcome.text(services.contentService)
    }()

    private lazy var dailyLearnPlan: String = {
        return Greeting.dailyLearnPlan.text(services.contentService)
    }()

    private lazy var dailyPrep: String = {
        return Greeting.dailyPrep.text(services.contentService)
    }()

    private lazy var guideAllCompleted: String = {
        return Greeting.guideAllCompleted.text(services.contentService)
    }()

    private lazy var guideTodayCompleted: String = {
        return Greeting.guideTodayCompleted.text(services.contentService)
    }()

    init(services: Services, eventTracker: EventTracker) {
        self.services = services
        self.eventTracker = eventTracker
        self.syncStateObserver = SyncStateObserver(realm: services.mainRealm)
        self.realmGuides = services.guideService.guideSections()
        self.guideWorker = GuideWorker(services: services)

        syncStateObserver.onUpdate { [unowned self] _ in
            self.createTodaysGuideIfNeeded()
        }
        becomeActiveHandler.handler = { [unowned self] _ in
            self.createTodaysGuideIfNeeded()
        }
        realmGuides.addNotificationBlock { [unowned self] _ in
            self.reload()
        }.addTo(tokenBin)
    }

    func reload() {
        let transformer = GuideTransformer()
        days = transformer.days(from: realmGuides, services: services)
        sectionCountUpdate.next(sectionCount)
        updates.next(.reload)
    }

    var message: String {
        let userName = services.mainRealm.objects(User.self).first?.givenName ?? "High Performer"
        let welcomeMessage = Date().isBeforeNoon == true ? "Good Morning" : "Hello"

        return String(format: "%@ %@,\n", welcomeMessage, userName)
    }

    func greeting() -> String {
        guard days.isEmpty == false, days.first?.items.isEmpty == false else { return "" }
        let indexPath = IndexPath(row: 0, section: 0)
        let firstItem = item(indexPath: indexPath)

        if firstItem.isDailyPrep == true && firstItem.isDailyPrepCompleted == false {
            return dailyPrep
        }

        if services.guideService.guideIsTotallyCompleted() == true {
            return guideAllCompleted
        }

        if days.count == 1 && services.guideService.guideNoneCompleted() == true {
            return welcome
        }

        if services.guideService.guideTodayCompleted() == true {
            return guideTodayCompleted
        }

        return dailyLearnPlan
    }

    var isReady: Bool {
        return guideWorker.hasCreatedTodaysGuide
    }

    var sectionCount: Int {
        return days.count
    }

    func numberOfRows(section: Int) -> Int {
        return days[section].items.count
    }

    func header(section: Int) -> Date {
        return days[section].createdAt
    }

    func item(indexPath: IndexPath) -> Guide.Item {
        return days[indexPath.section].items[indexPath.row]
    }

    func setCompleted(item: Guide.Item, completion: @escaping () -> Void) {
        guard item.status == .todo else { return }
        cancelPendingNotificationIfNeeded(item: item)
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
        guideWorker.createTodaysGuideIfNecessary()
    }
}
