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
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 2, isMyRate: false)
                                                                                   ]),
                                                   TeamVisionSentence.RatingResult(date: Date(),
                                                                                   ratings: [
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 2, isMyRate: false),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 7, isMyRate: false),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 10, isMyRate: true),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 1, isMyRate: false),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 0, isMyRate: false),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 2, isMyRate: false),
                                                                                    TeamVisionSentence.RatingResult.TeamVisionRating(rating: 3, isMyRate: false)
                                                                                   ]),
                                                   TeamVisionSentence.RatingResult(date: Date(),
                                                                                   ratings:
                                                                                    [TeamVisionSentence.RatingResult.TeamVisionRating(rating: 3, isMyRate: false),
                                                                                     TeamVisionSentence.RatingResult.TeamVisionRating(rating: 5, isMyRate: false),
                                                                                     TeamVisionSentence.RatingResult.TeamVisionRating(rating: 7, isMyRate: false),
                                                                                     TeamVisionSentence.RatingResult.TeamVisionRating(rating: 9, isMyRate: false),
                                                                                     TeamVisionSentence.RatingResult.TeamVisionRating(rating: 10, isMyRate: false),
                                                                                     TeamVisionSentence.RatingResult.TeamVisionRating(rating: 0, isMyRate: false),
                                                                                     TeamVisionSentence.RatingResult.TeamVisionRating(rating: 2, isMyRate: true)
                                                                                    ])]
    )

    var dataEntries1 = [
        BarEntry(scoreIndex: 1, votes: 0, isMyVote: false),
        BarEntry(scoreIndex: 2, votes: 0, isMyVote: false),
        BarEntry(scoreIndex: 3, votes: 6, isMyVote: false),
        BarEntry(scoreIndex: 4, votes: 2, isMyVote: true),
        BarEntry(scoreIndex: 5, votes: 9, isMyVote: false),
        BarEntry(scoreIndex: 6, votes: 200, isMyVote: false),
        BarEntry(scoreIndex: 7, votes: 3, isMyVote: false),
        BarEntry(scoreIndex: 8, votes: 10, isMyVote: false),
        BarEntry(scoreIndex: 9, votes: 20, isMyVote: false),
        BarEntry(scoreIndex: 10, votes: 39, isMyVote: false)
    ]

    var dataEntries2 = [
        BarEntry(scoreIndex: 1, votes: 0, isMyVote: false),
        BarEntry(scoreIndex: 2, votes: 10, isMyVote: true),
        BarEntry(scoreIndex: 3, votes: 6, isMyVote: false),
        BarEntry(scoreIndex: 4, votes: 2, isMyVote: true),
        BarEntry(scoreIndex: 5, votes: 4, isMyVote: false),
        BarEntry(scoreIndex: 6, votes: 9, isMyVote: false),
        BarEntry(scoreIndex: 7, votes: 38, isMyVote: false),
        BarEntry(scoreIndex: 8, votes: 5, isMyVote: false),
        BarEntry(scoreIndex: 9, votes: 8, isMyVote: false),
        BarEntry(scoreIndex: 10, votes: 0, isMyVote: false)
    ]

    var dataEntries3 = [
        BarEntry(scoreIndex: 1, votes: 10, isMyVote: false),
        BarEntry(scoreIndex: 2, votes: 3, isMyVote: false),
        BarEntry(scoreIndex: 3, votes: 30, isMyVote: false),
        BarEntry(scoreIndex: 4, votes: 4, isMyVote: false),
        BarEntry(scoreIndex: 5, votes: 17, isMyVote: false),
        BarEntry(scoreIndex: 6, votes: 18, isMyVote: false),
        BarEntry(scoreIndex: 7, votes: 2, isMyVote: false),
        BarEntry(scoreIndex: 8, votes: 25, isMyVote: false),
        BarEntry(scoreIndex: 9, votes: 5, isMyVote: true),
        BarEntry(scoreIndex: 10, votes: 10, isMyVote: false)
    ]
}
