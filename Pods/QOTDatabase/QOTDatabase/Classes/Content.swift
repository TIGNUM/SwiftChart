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
public final class Content: Object {
    public dynamic var id: Int = 0
    public dynamic var sort: Int = 0
    public dynamic var name: String = ""
    public dynamic var title: String = ""
    public let items = List<ContentItem>()
    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    convenience public init(id: Int, sort: Int, name: String, title: String) {
        self.init()
        self.id = id
        self.sort =  sort
        self.name = name
        self.title = title
    }
}

public extension Content {
    var percentageViewed: Double {
        let viewed = items.filter { $0.status == .viewed }
        return Double(viewed.count) / Double(items.count)
    }
}
