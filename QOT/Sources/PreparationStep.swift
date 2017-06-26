//
//  PreparationStep.swift
//  QOT
//
//  Created by Sam Wyndham on 26.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class PreparationStep: Object {

    // MARK: Private Properties

    private let _remoteID = RealmOptional<Int>(nil)

    // MARK: Public Properties

    private(set) dynamic var localID: String = UUID().uuidString

    private(set) dynamic var deleted: Bool = false

    private(set) dynamic var dirty: Bool = true

    private(set) dynamic var preparationID: Int = 0

    private(set) dynamic var contentItemID: Int = 0

    private(set) dynamic var timestamp: Date = Date()

    // MARK: Computed Properties

    var remoteID: Int? {
        return _remoteID.value
    }

    // MARK: Functions

    convenience init(preparationID: Int, contentItemID: Int, timestamp: Date = Date()) {
        self.init()
        self.preparationID = preparationID
        self.contentItemID = contentItemID
        self.timestamp = timestamp
    }

    override class func primaryKey() -> String? {
        return "localID"
    }
}
