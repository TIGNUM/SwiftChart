//
//  LearnContentCategory.swift
//  QOT
//
//  Created by Sam Wyndham on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import QOTDatabase

final class LearnContentService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func categories() -> DataProvider<LearnContentCategory> {
        let results = mainRealm.objects(ContentCategory.self).sorted(byKeyPath: "sortOrder")
        return DataProvider<LearnContentCategory>(results: results, map: { $0 as LearnContentCategory })
    }
}
