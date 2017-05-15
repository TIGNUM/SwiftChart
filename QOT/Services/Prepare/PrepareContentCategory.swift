//
//  PrepareContentCategory.swift
//  QOT
//
//  Created by karmic on 12.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PrepareContentCategory: TrackableEntity {

    var prepareContentCollection: DataProvider<PrepareContentCollection> { get }
}

extension ContentCategory: PrepareContentCategory {

    var prepareContentCollection: DataProvider<PrepareContentCollection> {
         return DataProvider(list: contentCollections, map: { $0 as PrepareContentCollection })
    }
}
