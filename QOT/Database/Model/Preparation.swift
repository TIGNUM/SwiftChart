///
//  Preparation.swift
//  QOT
//
//  Created by karmic on 23/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

// FIXME: Unit test once data model is finalized.
class Preparation: Object {

    enum ChatType {
        case instruction
        case preparation
        case dayProtocol
    }

    // MARK: - Properties

    dynamic var id: Int = 0
    dynamic var sort: Int = 0
    dynamic var name: String = ""
    dynamic var title: String = ""

    override class func primaryKey() -> String? {
        return Databsase.Key.primary.rawValue
    }

    // MARK: - Life Cycle

    // FIXME: Unit test once data model is finalized.
    convenience init(id: Int, sort: Int, name: String, title: String, chatType: ChatType) {
        self.init()
        self.id = id
        self.sort = sort
        self.name = name
        self.title = title
    }
}
