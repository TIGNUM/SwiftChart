//
//  QDMToBeVisionRatingReport+Ext.swift
//  QOT
//
//  Created by karmic on 09.12.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension QDMToBeVisionRatingReport {
    func ratingExist(at index: Int) -> Bool {
        if let date = dates.at(index: index),
           let averageRating = averages[date],
           !averageRating.isNaN,
           sentences.at(index: index) != nil {
            return true
        }
        return false
    }
}
