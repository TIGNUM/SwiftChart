//
//  ContentCategory.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

// FIXME: Unit test once data model is finalized.
final class ContentCategory: Object {
    dynamic var id: Int = 0
    dynamic var sort: Int = 0
    dynamic var name: String = ""
    dynamic var title: String = ""
    dynamic var radius: Double = 0
    dynamic var centerX: Double = 0
    dynamic var centerY: Double = 0
    let contents = List<Content>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    // FIXME: Unit test once data model is finalized.
    convenience init(id: Int, sort: Int, name: String, title: String, radius: Double, centerX: Double, centerY: Double) {
        self.init()
        self.id = id
        self.sort = sort
        self.name = name
        self.title = title
        self.radius = radius
        self.centerX = centerX
        self.centerY = centerY
    }
}
