//
//  LearnWhatsHotContentCollection.swift
//  QOT
//
//  Created by karmic on 09.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

protocol LearnWhatsHotContentCollection: TrackableEntity {

    var title: String { get }

    var localID: String { get }

    var selected: Bool { get }

    var learnWhatsHotItems: DataProvider<LearnWhatsHotContentItem> { get }

    var categoryIDs: List<IntObject> { get }

    var sortOrder: Int { get }

    var thumbnailURL: URL? { get}
}

extension ContentCollection: LearnWhatsHotContentCollection {

    var learnWhatsHotItems: DataProvider<LearnWhatsHotContentItem> {
        return DataProvider(items: items, map: { $0 as LearnWhatsHotContentItem })
    }

    var thumbnailURL: URL? {
        guard let stringURL = thumbnailURLString else {
            return nil
        }

        return URL(string: stringURL)
    }
}
