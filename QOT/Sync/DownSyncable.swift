//
//  DownSyncable.swift
//  Pods
//
//  Created by Sam Wyndham on 10/05/2017.
//
//

import Foundation
import RealmSwift

protocol DownSyncable: class {
    associatedtype Data

    static func make(remoteID: Int, createdAt: Date) -> Self

    var modifiedAt: Date { get set }

    func setData(_ data: Data, objectStore: ObjectStore) throws
}
