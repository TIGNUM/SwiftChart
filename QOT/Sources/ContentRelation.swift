//
//  ContentRelation.swift
//  QOT
//
//  Created by Sam Wyndham on 04.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class ContentRelation: Object {

    @objc private(set) dynamic var type: String = ""

    @objc private(set) dynamic var weight: Int = 0

    @objc private(set) dynamic var contentID: Int = 0

    convenience init(intermediary: ContentRelationIntermediary) {
        self.init()
        type = intermediary.type
        weight = intermediary.weight
        contentID = intermediary.contentID
    }
}
