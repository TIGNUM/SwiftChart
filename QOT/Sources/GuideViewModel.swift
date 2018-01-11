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

    init(services: Services, eventTracker: EventTracker) {
        self.services = services
        self.eventTracker = eventTracker
        self.syncStateObserver = SyncStateObserver(realm: services.mainRealm)
        self.realmGuides = services.guideService.guideSections()
        self.guideWorker = GuideWorker(services: services)

        syncStateObserver.observe(\.syncedClasses, options: [.new]) { [unowned self] _, _ in
            self.createTodaysGuideIfNeeded()
        }.addTo(tokenBin)
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

    func greeting(_ item: Guide.Item?) -> String {
        let sections = services.guideService.guideSections()
        if sections.count <= 1 {
            if let guide = sections.first, guide.items.filter({ $0.completedAt != nil }).isEmpty {
                return welcome
            } else {
                return dailyLearnPlan
            }
        }

        if item == nil {
            return dailyLearnPlan
        }

        if let item = item, item.isDailyPrep == true && item.isDailyPrepCompleted == false {
            if item.greeting.isEmpty == false {
                return item.greeting
            } else {
                return dailyPrep
            }
        }

        if let greeting = item?.greeting, greeting.isEmpty == false {
            return greeting
        } else {
            return dailyLearnPlan
        }
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
