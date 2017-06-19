//
//  LearnWhatsHotService.swift
//  QOT
//
//  Created by karmic on 09.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

protocol LearnWhatsHotServiceDelegate: class {

    func didSelectItem(with itemID: Int, from viewController: UIViewController)
}

final class LearnWhatsHotService {

    // MARK: - Properties

    private let mainRealm: Realm
    private let realmProvider: RealmProvider
    fileprivate var token: NotificationToken?

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func categories() -> DataProvider<LearnWhatsHotContentCategory> {
        let filter = String.realmSectionFilter(filter: Database.Section.learnWhatsHot.rawValue)
        let results = mainRealm.objects(ContentCategory.self).sorted(byKeyPath: "sortOrder").filter(filter)
        
        return DataProvider<LearnWhatsHotContentCategory>(items: results, map: { $0 as LearnWhatsHotContentCategory })
    }

    func updatedViewedAt(with itemId: Int) {
        DispatchQueue.global().async {
            do {
                let realm = try self.realmProvider.realm()
                try realm.write {
                    let contentItem = realm.object(ofType: ContentItem.self, forPrimaryKey: itemId)
                    contentItem?.viewed = true
                }
            } catch let error {
                assertionFailure("UpdateViewedAt, itemId: \(itemId), error: \(error)")
            }
        }
    }
}
