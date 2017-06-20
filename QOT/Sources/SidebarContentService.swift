//
//  SidebarContentService.swift
//  QOT
//
//  Created by karmic on 16.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class SidebarContentService {

    // MARK: - Properties

    private let mainRealm: Realm
    private let realmProvider: RealmProvider
    fileprivate var token: NotificationToken?

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func categories(with sectionFilter: String? = nil) -> DataProvider<SidebarContentCategory> {
        let filter = NSPredicate(section: sectionFilter ?? Database.Section.sidebar.value)
        let results = mainRealm.objects(ContentCategory.self)
            .sorted(byKeyPath: Database.ItemKey.sortOrder.value)
            .filter(filter)
        return DataProvider<SidebarContentCategory>(items: results, map: { $0 as SidebarContentCategory })
    }

    func collection(for collectionSection: String) -> DataProvider<SidebarContentCollection> {
        let filter = NSPredicate(section: collectionSection)
        let results = mainRealm.objects(ContentCollection.self)
            .sorted(byKeyPath: Database.ItemKey.sortOrder.value)
            .filter(filter)
        return DataProvider<SidebarContentCollection>(items: results, map: { $0 as SidebarContentCollection })
    }
}
