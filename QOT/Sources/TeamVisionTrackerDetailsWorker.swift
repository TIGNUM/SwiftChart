//
//  TeamVisionTrackerDetailsWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamVisionTrackerDetailsWorker {

//    private let report: ToBeVisionReport
//    private let selectedSentence: String
    var dataEntries1 = [BarEntry]()
    var dataEntries2 = [BarEntry]()
    var dataEntries3 = [BarEntry]()

    // MARK: - Init
    init(report: ToBeVisionReport, selectedSentence: String) {
        createData(report: report, selectedSentence: selectedSentence)
    }
}

private extension TeamVisionTrackerDetailsWorker {
    func createData(report: ToBeVisionReport, selectedSentence: String) {
        for (index, poll) in report.report.polls.enumerated() {
            if let report = (poll.qotTeamToBeVisionTrackers?.filter { $0.sentence == selectedSentence })?.first,
               let ratings = report.qotTeamToBeVisionTrackerRatings, ratings.isEmpty == false {
                if index == 0 {
                    for ratingIndex in 1...10 {
                        let entry = getBarEntry(index: ratingIndex, ratings: ratings)
                        dataEntries1.append(entry)
                    }
                }

                if index == 1 {
                    for ratingIndex in 1...10 {
                        let entry = getBarEntry(index: ratingIndex, ratings: ratings)
                        dataEntries2.append(entry)
                    }
                }

                if index == 2 {
                    for ratingIndex in 1...10 {
                        let entry = getBarEntry(index: ratingIndex, ratings: ratings)
                        dataEntries3.append(entry)
                    }
                }
            }
        }
    }

    func getBarEntry(index: Int, ratings: [QDMTeamToBeVisionTrackerRating]) -> BarEntry {
        let rating = ratings.filter { $0.rating == index }
        let isMyRating = rating.filter { $0.isMyRating == true }.isEmpty == false
        return BarEntry(scoreIndex: index, votes: rating.count, isMyVote: isMyRating)
    }
}
//    var dataEntries1 = [
//        BarEntry(scoreIndex: 10, votes: 0, isMyVote: false),
//        BarEntry(scoreIndex: 9, votes: 0, isMyVote: false),
//        BarEntry(scoreIndex: 8, votes: 6, isMyVote: false),
//        BarEntry(scoreIndex: 7, votes: 2, isMyVote: true),
//        BarEntry(scoreIndex: 6, votes: 9, isMyVote: false),
//        BarEntry(scoreIndex: 5, votes: 200, isMyVote: false),
//        BarEntry(scoreIndex: 4, votes: 3, isMyVote: false),
//        BarEntry(scoreIndex: 3, votes: 10, isMyVote: false),
//        BarEntry(scoreIndex: 2, votes: 20, isMyVote: false),
//        BarEntry(scoreIndex: 1, votes: 39, isMyVote: false)
//    ]
//
//    var dataEntries2 = [
//        BarEntry(scoreIndex: 10, votes: 0, isMyVote: false),
//        BarEntry(scoreIndex: 9, votes: 10, isMyVote: true),
//        BarEntry(scoreIndex: 8, votes: 6, isMyVote: false),
//        BarEntry(scoreIndex: 7, votes: 2, isMyVote: false),
//        BarEntry(scoreIndex: 6, votes: 4, isMyVote: false),
//        BarEntry(scoreIndex: 5, votes: 9, isMyVote: false),
//        BarEntry(scoreIndex: 4, votes: 38, isMyVote: false),
//        BarEntry(scoreIndex: 3, votes: 5, isMyVote: false),
//        BarEntry(scoreIndex: 2, votes: 8, isMyVote: false),
//        BarEntry(scoreIndex: 1, votes: 0, isMyVote: false)
//    ]
//
//    var dataEntries3 = [
//        BarEntry(scoreIndex: 10, votes: 10, isMyVote: false),
//        BarEntry(scoreIndex: 9, votes: 3, isMyVote: false),
//        BarEntry(scoreIndex: 8, votes: 30, isMyVote: false),
//        BarEntry(scoreIndex: 7, votes: 4, isMyVote: false),
//        BarEntry(scoreIndex: 6, votes: 17, isMyVote: false),
//        BarEntry(scoreIndex: 5, votes: 18, isMyVote: false),
//        BarEntry(scoreIndex: 4, votes: 2, isMyVote: false),
//        BarEntry(scoreIndex: 3, votes: 25, isMyVote: false),
//        BarEntry(scoreIndex: 2, votes: 5, isMyVote: true),
//        BarEntry(scoreIndex: 1, votes: 10, isMyVote: false)
//    ]
//}
