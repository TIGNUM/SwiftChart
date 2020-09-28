//
//  TeamVisionTrackerDetailsWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamVisionTrackerDetailsWorker {

    // MARK: - Init
    init() { /**/ }

    var model = TeamVisionSentence(sentence: "We are an inspired, energized, dynamic, and agile group of people who maximizes the impact and performance of everyoen we touch - both isnde and outside of TIGNUM.",
                                   ratingResults: [TeamVisionSentence.RatingResult(date: Date(),
                                                                                   ratings: [
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 2, isMyRate: false),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 7, isMyRate: false),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 2, isMyRate: false),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 10, isMyRate: true),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 2, isMyRate: false),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 3, isMyRate: false),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 2, isMyRate: false),
                                                                                   ]),
                                                   TeamVisionSentence.RatingResult(date: Date(),
                                                                                   ratings: [
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 2, isMyRate: false),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 7, isMyRate: false),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 10, isMyRate: true),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 1, isMyRate: false),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 0, isMyRate: false),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 2, isMyRate: false),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 3, isMyRate: false),
                                                                                   ]),
                                                   TeamVisionSentence.RatingResult(date: Date(),
                                                                                   ratings:
                                                                                    [TeamVisionSentence.RatingResult.TeamVisionRating(rating: 3, isMyRate: false),
                                                                                     TeamVisionSentence.RatingResult.TeamVisionRating(rating: 5, isMyRate: false),
                                                                                     TeamVisionSentence.RatingResult.TeamVisionRating(rating: 7, isMyRate: false),
                                                                                     TeamVisionSentence.RatingResult.TeamVisionRating(rating: 9, isMyRate: false),
                                                                                     TeamVisionSentence.RatingResult.TeamVisionRating(rating: 10, isMyRate: false),
                                                                                     TeamVisionSentence.RatingResult.TeamVisionRating(rating: 0, isMyRate: false),
                                                                                     TeamVisionSentence.RatingResult.TeamVisionRating(rating: 2, isMyRate: true),
                                                                                    ])]
    )
}
