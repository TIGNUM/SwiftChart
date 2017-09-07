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
    let myStatisticsService: MyStatisticsService
    let mediaService: MediaService

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
        self.myStatisticsService = MyStatisticsService(mainRealm: mainRealm, realmProvider: realmProvider)
        self.mediaService = MediaService(mainRealm: mainRealm, realmProvider: realmProvider)
    }
}
