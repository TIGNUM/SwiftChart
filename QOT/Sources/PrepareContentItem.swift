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

protocol PrepareContentItem {

    var title: String { get }

    var subTitle: String { get }
}

extension ContentItem: PrepareContentItem {

    var subTitle: String {
        return "subTitle"
    }

    var title: String {
        return "title"
    }
}

struct PrepareItem: PrepareContentItem {
    var title: String
    var subTitle: String
    var readMoreID: Int?
    
    init(title: String, subTitle: String, readMoreID: Int?) {
        self.title = title
        self.subTitle = subTitle
        self.readMoreID = readMoreID
    }
}
