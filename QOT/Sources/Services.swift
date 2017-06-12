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

    let learnContentService: LearnContentService
    let learnWhatsHotService: LearnWhatsHotService
    let prepareContentService: PrepareContentService
    let sidebarContentService: SidebarContentService
    weak var learnCategoryUpdateDelegate: LearnCategoryUpdateDelegate?

    init(
        learnContentService: LearnContentService,
        learnWhatsHotService: LearnWhatsHotService,
        prepareContentService: PrepareContentService,
        sidebarContentService: SidebarContentService) {
            self.learnContentService = learnContentService
            self.learnWhatsHotService = learnWhatsHotService
            self.prepareContentService = prepareContentService
            self.sidebarContentService = sidebarContentService
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
                    let learnContentService = LearnContentService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let learnWhatsHotService = LearnWhatsHotService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let prepareContentService = PrepareContentService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let sidebarContentService = SidebarContentService(mainRealm: mainRealm, realmProvider: realmProvider)
                    let services = Services(
                        learnContentService: learnContentService,
                        learnWhatsHotService: learnWhatsHotService,
                        prepareContentService: prepareContentService,
                        sidebarContentService: sidebarContentService
                    )

                    completion(.success(services))
                } catch let error as NSError {
                    completion(.failure(error))
                }
            }
        }
    }
}

extension Services: LearnContentServiceDelegate {

    func updatedViewedAt(with itemId: Int) {
        learnContentService.updatedViewedAt(with: itemId)
    }
}
