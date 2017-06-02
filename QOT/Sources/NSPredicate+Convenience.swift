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
}
