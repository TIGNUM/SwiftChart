//
//  Page.swift
//  QOT
//
//  Created by Sam Wyndham on 15.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class Page: SyncableObject {

    // MARK: Data

    @objc fileprivate(set) dynamic var name: String = ""

    /// The display name in the Admin Tool. We might not use this in the app.
    @objc fileprivate(set) dynamic var displayName: String?

    @objc fileprivate(set) dynamic var layoutInfo: String?

    // MARK: Relationships

    // FIXME: Implement settings relationship
}

extension Page: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .page
    }

    func setData(_ data: PageIntermediary, objectStore: ObjectStore) throws {
        name = data.name
        displayName = data.displayName
        layoutInfo = data.layoutInfo
    }
}
