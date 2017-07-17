//
//  MyStatisticsService.swift
//  QOT
//
//  Created by karmic on 12.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class MyStatisticsService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func allCardObjects() -> AnyRealmCollection<MyStatistics> {
        let results = mainRealm.objects(MyStatistics.self)
        
        return AnyRealmCollection(results)
    }

    func card(key: String) -> MyStatistics? {
        let predicate = NSPredicate(format: "key == %@", key)

        return allCardObjects().filter(predicate).first
    }

    func cards() throws -> [[MyStatistics]] {
        var results = [[MyStatistics]]()
        var cardSections = [MyStatistics]()

        MyStatisticsCardType.allValues.forEach { (cardType: MyStatisticsCardType) in
            cardType.keys.forEach({ (key: String) in
                if let card = card(key: key) {
                    cardSections.append(card)
                }

                results.append(cardSections)
            })
        }

        return results
    }
}
