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
