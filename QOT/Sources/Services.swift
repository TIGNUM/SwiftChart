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
    let articleService: ArticleService
    let preparationService: PreparationService
    let questionsService: QuestionsService
    let partnerService: PartnerService
    let userService: UserService
    let eventsService: EventsService
    let settingsService: SettingsService
    lazy var trackingService: EventTracker = {
        return EventTracker(realmProvider: { return try Realm() })
    }()

    init(
        mainRealm: Realm,
        contentService: ContentService,
        articleService: ArticleService,
        preparationService: PreparationService,
        questionsService: QuestionsService,
        partnerService: PartnerService,
        userService: UserService,
        eventsService: EventsService,
        settingsService: SettingsService) {
            self.mainRealm = mainRealm
            self.contentService = contentService
            self.articleService = articleService
            self.preparationService = preparationService
            self.questionsService = questionsService
            self.partnerService = partnerService
            self.userService = userService
            self.eventsService = eventsService
            self.settingsService = settingsService
    }

    static func make(completion: @escaping (Result<Services, NSError>) -> Void) {
        DispatchQueue.global().async {
            // Do expensive things here such as migrations.

            // FIXME: Remove
            do {
                setupRealmWithMockData(realm: try Realm())
            } catch let error {
                fatalError("Cannot create mock data: \(error)")
            }

            DispatchQueue.main.async {
                do {
                    let realmProvider = RealmProvider()
                    let mainRealm = try realmProvider.realm()
                    let contentService = ContentService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let articleService = ArticleService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let preparationService = PreparationService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let questionsService = QuestionsService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let partnerService = PartnerService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let userService = UserService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let eventsService = EventsService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let settingsService = SettingsService(realm: mainRealm)
                    let services = Services(
                        mainRealm: mainRealm,
                        contentService: contentService,
                        articleService: articleService,
                        preparationService: preparationService,
                        questionsService: questionsService,
                        partnerService: partnerService,
                        userService: userService,
                        eventsService: eventsService,
                        settingsService: settingsService
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
