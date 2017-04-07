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
public final class ContentCategory: Object {
    public dynamic var id: Int = 0
    public dynamic var sort: Int = 0
    public dynamic var name: String = ""
    public dynamic var title: String = ""
    public dynamic var radius: Double = 0
    public dynamic var centerX: Double = 0
    public dynamic var centerY: Double = 0
    public let contents = List<Content>()
    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    // FIXME: Unit test once data model is finalized.
    convenience public init(id: Int, sort: Int, name: String, title: String, radius: Double, centerX: Double, centerY: Double) {
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
