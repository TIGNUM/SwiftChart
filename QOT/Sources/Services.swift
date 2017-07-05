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
    let prepareContentService: PrepareContentService
    let questionsService: QuestionsService
    let partnerService: PartnerService
    let userService: UserService
    lazy var trackingService: EventTracker = {
        return EventTracker(realmProvider: { return try Realm() })
    }()

    init(
        mainRealm: Realm,
        contentService: ContentService,
        articleService: ArticleService,
        prepareContentService: PrepareContentService,
        questionsService: QuestionsService,
        partnerService: PartnerService,
        userService: UserService) {
            self.mainRealm = mainRealm
            self.contentService = contentService
            self.articleService = articleService
            self.prepareContentService = prepareContentService
            self.questionsService = questionsService
            self.partnerService = partnerService
            self.userService = userService
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
                    let prepareContentService = PrepareContentService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let questionsService = QuestionsService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let partnerService = PartnerService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let userService = UserService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let services = Services(
                        mainRealm: mainRealm,
                        contentService: contentService,
                        articleService: articleService,
                        prepareContentService: prepareContentService,
                        questionsService: questionsService,
                        partnerService: partnerService,
                        userService: userService
                    )

                    completion(.success(services))
                } catch let error as NSError {
                    completion(.failure(error))
                }
            }
        }
    }
}
