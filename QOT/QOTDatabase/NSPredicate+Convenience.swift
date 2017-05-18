//
//  NSPredicate+Convenience.swift
//  Pods
//
//  Created by Sam Wyndham on 11/05/2017.
//
//

import Foundation

public extension NSPredicate {
    public convenience init(remoteID: Int) {
        self.init(format: "remoteID == %@", remoteID)
    }
}
