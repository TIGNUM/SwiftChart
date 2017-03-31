//
//  LearnContentCategory.swift
//  QOT
//
//  Created by Sam Wyndham on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class LearnContentService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func categories() -> DataProvider<LearnCategory> {
        let results = mainRealm.objects(ContentCategory.self).sorted(byKeyPath: "sort")
        return DataProvider<LearnCategory>(results: results, map: { $0 as LearnCategory })
    }

    func category(ID: String) -> LearnCategory? {
        return mainRealm.object(ofType: ContentCategory.self, forPrimaryKey: "id")
    }
}
