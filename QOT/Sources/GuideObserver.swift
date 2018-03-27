//
//  GuideObserver.swift
//  QOT
//
//  Created by Sam Wyndham on 24/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import RealmSwift

final class GuideObserver {

    private let syncStateObserver: SyncStateObserver
    private let notificationItems: Results<RealmGuideItemNotification>
    private let learnItems: Results<RealmGuideItemLearn>
    private let dailyPrepResults: Results<DailyPrepResultObject>
    private let preparations: Results<Preparation>
    private let becomeActiveHandler = NotificationHandler(name: .UIApplicationDidBecomeActive)
    private var tokenBin = TokenBin()

    var guideDidChange: (() -> Void)?

    init(services: Services) {
        self.syncStateObserver = SyncStateObserver(realm: services.mainRealm)
        self.notificationItems = services.guideService.notificationItems()
        self.learnItems = services.guideService.learnItems()
        self.dailyPrepResults = services.mainRealm.objects(DailyPrepResultObject.self)
        self.preparations = services.mainRealm.objects(Preparation.self)

        syncStateObserver.onUpdate { [unowned self] _ in
            self.guideDidChange?()
        }
        becomeActiveHandler.handler = { [unowned self] _ in
            self.guideDidChange?()
        }
        notificationItems.addNotificationBlock { [unowned self] _ in
            self.guideDidChange?()
            }.addTo(tokenBin)
        learnItems.addNotificationBlock { [unowned self] _ in
            self.guideDidChange?()
            }.addTo(tokenBin)
        dailyPrepResults.addNotificationBlock { [unowned self] _ in
            self.guideDidChange?()
            }.addTo(tokenBin)
        preparations.addNotificationBlock { [unowned self] _ in
            self.guideDidChange?()
            }.addTo(tokenBin)
    }
}
