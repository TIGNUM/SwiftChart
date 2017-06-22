//
//  NSPredicate+Convenience.swift
//  Pods
//
//  Created by Sam Wyndham on 11/05/2017.
//
//

import Foundation

extension NSPredicate {
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
}
