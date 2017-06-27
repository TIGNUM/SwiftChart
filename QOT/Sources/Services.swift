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
    let sidebarContentService: SidebarContentService
    let questionsService: QuestionsService
    weak var learnCategoryUpdateDelegate: LearnCategoryUpdateDelegate?

    init(
        mainRealm: Realm,
        contentService: ContentService,
        articleService: ArticleService,
        prepareContentService: PrepareContentService,
        sidebarContentService: SidebarContentService,
        questionsService: QuestionsService) {
            self.mainRealm = mainRealm
            self.contentService = contentService
            self.articleService = articleService
            self.prepareContentService = prepareContentService
            self.sidebarContentService = sidebarContentService            
            self.questionsService = questionsService
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
                    let sidebarContentService = SidebarContentService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let questionsService = QuestionsService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let services = Services(
                        mainRealm: mainRealm,
                        contentService: contentService,
                        articleService: articleService,
                        prepareContentService: prepareContentService,
                        sidebarContentService: sidebarContentService,
                        questionsService: questionsService
                    )

                    completion(.success(services))
                } catch let error as NSError {
                    completion(.failure(error))
                }
            }
        }
    }
}
