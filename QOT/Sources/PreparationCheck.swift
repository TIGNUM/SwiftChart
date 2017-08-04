//
//  PreparationStep.swift
//  QOT
//
//  Created by Sam Wyndham on 26.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class PreparationCheck: SyncableObject {

    // MARK: Public Properties

    private(set) dynamic var deleted: Bool = false

    private(set) dynamic var dirty: Bool = true

    private(set) dynamic var preparationID: String = ""

    private(set) dynamic var contentItemID: Int = 0

    private(set) dynamic var timestamp: Date = Date()

    // MARK: Functions

    convenience init(preparationID: String, contentItemID: Int, timestamp: Date) {
        self.init()
        self.preparationID = preparationID
        self.contentItemID = contentItemID
        self.timestamp = timestamp
    }

    override func delete() {
        if let realm = realm {
            if remoteID.value == nil {
                realm.delete(self)
            } else {
                deleted = true
                dirty = true
            }
        }
    }
}
