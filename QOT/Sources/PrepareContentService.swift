//
//  PrepareContentService.swift
//  QOT
//
//  Created by karmic on 12.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class PrepareContentService {

    // MARK: - Properties

    private let mainRealm: Realm
    private let realmProvider: RealmProvider
    fileprivate var token: NotificationToken?

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func categories() -> AnyRealmCollection<ContentCategory> {
        let filter = NSPredicate(section: Database.Section.prepareCoach.rawValue)
        let results = mainRealm.objects(ContentCategory.self).sorted(byKeyPath: "sortOrder").filter(filter)
        return AnyRealmCollection<ContentCategory>(results)
    }
}
