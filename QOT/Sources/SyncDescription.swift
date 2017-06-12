//
//  SyncDescription.swift
//  QOT
//
//  Created by Sam Wyndham on 29.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

let ContentCategoryDown = SyncDescription<ContentCategoryData, ContentCategory>(syncType: .contentCategoryDown)
let ContentCollectionDown = SyncDescription<ContentCollectionData, ContentCollection>(syncType: .contentCollectionDown)
let ContentItemDown = SyncDescription<ContentItemData, ContentItem>(syncType: .contentItemDown)

struct SyncDescription<Intermediary, Persistable> where Intermediary: JSONDecodable {
    let syncType: SyncType
}
