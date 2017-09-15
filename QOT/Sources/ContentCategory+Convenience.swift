//
//  ContentCategory+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 24.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

extension ContentCategory {

    func itemCount(section: Database.Section) -> Int {
        return contentCollections(section: section).count
    }

    func viewedCount(section: Database.Section) -> Int {
        let filtered: LazyFilterCollection<AnyRealmCollection<ContentCollection>>
            = contentCollections(section: section).filter { $0.viewed }
        return filtered.count
    }

    var learnContent: AnyRealmCollection<ContentCollection> {
        return contentCollections(section: .learnStrategy)
    }

    func contentCollections(section: Database.Section) -> AnyRealmCollection<ContentCollection> {
        return AnyRealmCollection(contentCollections.filter(NSPredicate(section: section.rawValue)))
    }
}
