//
//  NSPredicate+Convenience.swift
//  Pods
//
//  Created by Sam Wyndham on 11/05/2017.
//
//

import Foundation

extension NSPredicate {

    static func section(_ section: Database.Section) -> NSPredicate {
        return NSPredicate(section: section.value)
    }

    static func preparationID(_ id: String) -> NSPredicate {
        return NSPredicate(format: "preparationID == %@", id)
    }

    static func key(_ key: String) -> NSPredicate {
        return NSPredicate(format: "key == %@", key)
    }

    static func deleted(_ deleted: Bool) -> NSPredicate {
        return NSPredicate(format: "deleted == %@", NSNumber(value: deleted))
    }

    static func questionGroupIDis(_ id: Int) -> NSPredicate {
        return NSPredicate(format: "questionGroupID == %d", id)
    }

    convenience init(remoteID: Int) {
        self.init(format: "remoteID == %d", remoteID)
    }
    
    convenience init(section: String) {
        self.init(format: "section == %@", section)
    }

    convenience init(remoteIDs: [Int]) {
        self.init(format: "remoteID IN %@", remoteIDs)
    }

    convenience init(dirty: Bool) {
        self.init(format: "dirty == %@", NSNumber(value: dirty))
    }

    convenience init(eventIDs: [String]) {
        self.init(format: "eventID IN %@", eventIDs)
    }

    convenience init(groupContains word: String) {
        self.init(format: "group CONTAINS %@", word)
    }
}
