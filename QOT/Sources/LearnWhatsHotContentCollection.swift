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
}

extension ContentCollection: LearnWhatsHotContentCollection {

    var learnWhatsHotItems: DataProvider<LearnWhatsHotContentItem> {
        return DataProvider(list: items, map: { $0 as LearnWhatsHotContentItem })
    }
}

