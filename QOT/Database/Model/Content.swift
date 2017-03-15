//
//  Content.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

// FIXME: Unit test once data model is finalized.
final class Content: Object {
    dynamic var id: Int = 0
    dynamic var sort: Int = 0
    dynamic var name: String = ""
    dynamic var title: String = ""
    let items = List<ContentItem>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, sort: Int, name: String, title: String) {
        self.init()
        self.id = id
        self.sort =  sort
        self.name = name
        self.title = title
    }
}

extension Content {
    var percentageViewed: Double {
        let viewed = items.filter { $0.status == .viewed }
        return Double(viewed.count) / Double(items.count)
    }
}
