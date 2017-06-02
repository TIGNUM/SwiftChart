//
//  PrepareContentItem.swift
//  QOT
//
//  Created by karmic on 12.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

protocol PrepareContentItem: TrackableEntity {

    var contentItemValue: ContentItemValue { get }

    func accordionTitle() -> String?
}

extension ContentItem: PrepareContentItem {

}
