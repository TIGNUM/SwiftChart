//
//  RealmEvent.swift
//  QOT
//
//  Created by Sam Wyndham on 13/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

/// Tracks a visit to a *page*.
///
/// A *page* is an abstract name for a view on a screen. It will usually refer to a particular `UIViewController`.
final class PageEvent: Object {
    /// The date the event was created.
    private(set) dynamic var created: Date = Date()
    /// The ID of the page.
    private(set) dynamic var pageID: String = ""
    /// The ID of the previous page or `nil` if no previous page.
    private(set) dynamic var referrerPageID: String?
    private let _associatedEntityID: RealmOptional<Int> = RealmOptional<Int>()

    convenience init(pageID: PageID, referrerPageID: PageID?, associatedEntityID: Int?) {
        self.init()
        
        self.pageID = pageID.rawValue
        self.referrerPageID = referrerPageID?.rawValue
        self._associatedEntityID.value = associatedEntityID
    }
    
    /// The ID of the model object/entity associated with the page or `nil` if none exists.
    var associatedEntityID: Int? {
        return _associatedEntityID.value
    }
}
