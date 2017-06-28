//
//  Preparation.swift
//  QOT
//
//  Created by Sam Wyndham on 26.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class Preparation: Object {

    // MARK: Private Properties

    private let _remoteID = RealmOptional<Int>(nil)

    // MARK: Public Properties

    private(set) dynamic var localID: String = UUID().uuidString

    private(set) dynamic var eventID: String?

    private(set) dynamic var deleted: Bool = false

    private(set) dynamic var dirty: Bool = true

    private(set) dynamic var contentID: Int = 0

    // MARK: Computed Properties

    var remoteID: Int? {
        return _remoteID.value
    }

    // MARK: Functions

    convenience init(contentID: Int, eventID: String?) {
        self.init()
        self.contentID = contentID
        self.eventID = eventID
    }

    override class func primaryKey() -> String? {
        return "localID"
    }
}
