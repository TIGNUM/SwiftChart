//
//  LearnContentCategory.swift
//  QOT
//
//  Created by Sam Wyndham on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

protocol LearnContentServiceDelegate: class {
    func updatedViewedAt(with itemId: Int, at date: Date)
}

final class LearnContentService {

    // MARK: - Properties

    private let mainRealm: Realm
    private let realmProvider: RealmProvider
    fileprivate var token: NotificationToken?
    weak var learnCategoryUpdateDelegate: LearnCategoryUpdateDelegate?

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func categories() -> DataProvider<LearnContentCategory> {
        let results = mainRealm.objects(ContentCategory.self).sorted(byKeyPath: "sortOrder").filter("section == 'learn.strategie'")
        self.token = mainRealm.addNotificationBlock({ (_, _) in
            self.learnCategoryUpdateDelegate?.didUpdateCategoryViewedPercentage()
        })
        return DataProvider<LearnContentCategory>(results: results, map: { $0 as LearnContentCategory })
    }

    func updatedViewedAt(with itemId: Int, at date: Date) {
        DispatchQueue.global().async {
            do {
                let realm = try self.realmProvider.realm()
                try realm.write {
                    let contentItem = realm.object(ofType: ContentItem.self, forPrimaryKey: itemId)
                    contentItem?.viewAt = date
                }
            } catch let error {
                assertionFailure("UpdateViewedAt, itemId: \(itemId), date: \(date), error: \(error)")
            }
        }
    }
}
