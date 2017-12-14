//
//  Services.swift
//  QOT
//
//  Created by Sam Wyndham on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

final class Services {

    let mainRealm: Realm
    let contentService: ContentService
    let preparationService: PreparationService
    let questionsService: QuestionsService
    let partnerService: PartnerService
    let userService: UserService
    let eventsService: EventsService
    let settingsService: SettingsService
    let statisticsService: StatisticsService
    let mediaService: MediaService
    let feedbackService: FeedbackService
    let guidePlanItemLearnService: GuideItemLearnService
    let guidePlanItemNotificationService: GuidePlanItemNotificationService
    let guidePlanService: GuideService

    init() throws {
        let realmProvider = RealmProvider()
        let mainRealm = try realmProvider.realm()
        self.mainRealm = mainRealm
        self.contentService = ContentService(mainRealm: mainRealm, realmProvider: realmProvider)
        self.preparationService = PreparationService(mainRealm: mainRealm, realmProvider: realmProvider)
        self.questionsService = QuestionsService(mainRealm: mainRealm, realmProvider: realmProvider)
        self.partnerService = PartnerService(mainRealm: mainRealm, realmProvider: realmProvider)
        self.userService = UserService(mainRealm: mainRealm, realmProvider: realmProvider)
        self.eventsService = EventsService(mainRealm: mainRealm, realmProvider: realmProvider)
        self.settingsService = SettingsService(realm: mainRealm)
        self.statisticsService = StatisticsService(mainRealm: mainRealm, realmProvider: realmProvider)
        self.mediaService = MediaService(mainRealm: mainRealm, realmProvider: realmProvider)
        self.feedbackService = FeedbackService(mainRealm: mainRealm, realmProvider: realmProvider)
        self.guidePlanItemNotificationService = GuidePlanItemNotificationService(mainRealm: mainRealm, realmProvider: realmProvider)
        self.guidePlanItemLearnService = GuideItemLearnService(mainRealm: mainRealm, realmProvider: realmProvider)
        self.guidePlanService = GuideService(mainRealm: mainRealm, realmProvider: realmProvider)
    }
}
