//
//  TeamVisionTrackerDetailsModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

struct TeamVisionSentence {
    var sentence: String
    var ratingResults: [RatingResult]

    struct RatingResult {
        var date: Date
        var ratings: [TeamVisionRating]

        struct TeamVisionRating {
            var rating: Int
            var isMyRate: Bool
        }
    }
}
