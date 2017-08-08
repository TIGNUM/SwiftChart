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

    init(
        mainRealm: Realm,
        contentService: ContentService,
        preparationService: PreparationService,
        questionsService: QuestionsService,
        partnerService: PartnerService,
        userService: UserService,
        eventsService: EventsService,
        settingsService: SettingsService,
        myStatisticsService: MyStatisticsService,
        mediaService: MediaService) {
            self.mainRealm = mainRealm
            self.contentService = contentService
            self.preparationService = preparationService
            self.questionsService = questionsService
            self.partnerService = partnerService
            self.userService = userService
            self.eventsService = eventsService
            self.settingsService = settingsService
            self.myStatisticsService = myStatisticsService
            self.mediaService = mediaService
    }

    static func make(completion: @escaping (Result<Services, NSError>) -> Void) {
        DispatchQueue.global().async {
            // Do expensive things here such as migrations.

            DispatchQueue.main.async {
                do {
                    let realmProvider = RealmProvider()
                    let mainRealm = try realmProvider.realm()
                    let contentService = ContentService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let preparationService = PreparationService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let questionsService = QuestionsService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let partnerService = PartnerService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let userService = UserService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let eventsService = EventsService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let settingsService = SettingsService(realm: mainRealm)
                    let myStatisticsService = MyStatisticsService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let mediaService = MediaService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let services = Services(
                        mainRealm: mainRealm,
                        contentService: contentService,
                        preparationService: preparationService,
                        questionsService: questionsService,
                        partnerService: partnerService,
                        userService: userService,
                        eventsService: eventsService,
                        settingsService: settingsService,
                        myStatisticsService: myStatisticsService,
                        mediaService: mediaService
                    )
                    
                    do {
                        try userService.prepare()
                        completion(.success(services))
                    } catch let error as NSError {
                        completion(.failure(error))
                    }
                } catch let error as NSError {
                    completion(.failure(error))
                }
            }
        }
    }
}
