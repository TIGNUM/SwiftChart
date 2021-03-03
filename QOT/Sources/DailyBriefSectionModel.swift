//
//  DailyBriefModel.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import DifferenceKit

struct DailyBriefSectionModel: Differentiable {
    typealias DifferenceIdentifier = String
    var differenceIdentifier: DifferenceIdentifier {
        return self.title ?? String.empty
    }
    var title: String?
    var sortOrder: Int

    func isContentEqual(to source: DailyBriefSectionModel) -> Bool {
        return title == source.title &&
               sortOrder == source.sortOrder
    }
}
