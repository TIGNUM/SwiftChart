//
//  LearnWhatsHotContentCategory.swift
//  QOT
//
//  Created by karmic on 09.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

/// Encapsulates data to display in a `LearnCategoryListViewController`.
protocol LearnWhatsHotContentCategory: TrackableEntity {

    var learnWhatsHotContent: DataProvider<LearnWhatsHotContentCollection> { get }
}

extension ContentCategory: LearnWhatsHotContentCategory {

    var learnWhatsHotContent: DataProvider<LearnWhatsHotContentCollection> {
        return DataProvider(items: contentCollections, map: { $0 as LearnWhatsHotContentCollection })
    }
}
