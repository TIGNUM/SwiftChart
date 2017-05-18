//
//  Syncable.swift
//  Pods
//
//  Created by Sam Wyndham on 06/04/2017.
//
//

import Foundation

// FIXME: Unit test to ensure raw values values don't change.
enum SyncStatus: Int8 {
    case clean = 0
    case updated = 1
    case deleted = 2
}

protocol Syncable {
    associatedtype Data
    associatedtype Parent

    var localID: String { get }
    var remoteID: Int? { get set }
    var syncStatus: SyncStatus { get set }
    var modifiedAt: Date { get set } // Just use to resolve conflicts
    var parent: Parent? { get set }

    func setData(_ data: Data) throws
}

enum NoParent {}
