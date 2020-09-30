//
//  MyToBeVisionRateWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyToBeVisionRateWorker {

    private let userService = UserService.main
    private let visionId: Int
    let team: QDMTeam?
    private var isOwner: Bool
    private let viewController: MyToBeVisionRateViewController
    var questions: [RatingQuestionViewModel.Question]?
    var dataTracks: [QDMToBeVisionTrack]?
    var teamDataTracks: [QDMTeamToBeVisionTrackerResult]?

    init(visionId: Int, viewController: MyToBeVisionRateViewController, team: QDMTeam?, isOwner: Bool) {
        self.visionId = visionId
        self.viewController = viewController
        self.team = team
        self.isOwner = isOwner
    }

    func getQuestions(_ completion: @escaping (_ tracks: [RatingQuestionViewModel.Question]) -> Void) {
        guard let team = team else {
        userService.getToBeVisionTracksForRating { [weak self] (tracks) in
            guard let strongSelf = self else { return }
            let finalTracks = tracks.filter { $0.toBeVisionId == strongSelf.visionId }
            strongSelf.dataTracks = finalTracks

            let questions = finalTracks.compactMap { (track) -> RatingQuestionViewModel.Question? in
                guard let remoteID = track.remoteID else { return nil }
                let question = track.sentence
                let range = 10
                return RatingQuestionViewModel.Question(remoteID: remoteID,
                                                        title: question ?? "",
                                                        htmlTitle: nil,
                                                        subtitle: nil,
                                                        dailyPrepTitle: nil,
                                                        key: nil,
                                                        answers: nil,
                                                        range: range,
                                                        selectedAnswerIndex: nil)
            }
            strongSelf.questions = questions
            completion(questions)
        }
            return
        }
        TeamService.main.currentTeamToBeVisionTrackerPoll(for: team) { (trackerPoll, _, error) in
            if let error = error {
                log("Error currentTeamToBeVisionTrackerPoll \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
//            if trackerPoll == nil {
                TeamService.main.openNewTeamToBeVisionTrackerPoll(for: team) { (newTrackerPoll, _, error) in
                    if let error = error {
                        log("Error openNewTeamToBeVisionTrackerPoll \(error.localizedDescription)", level: .error)
                        // TODO handle error
                    }
                    self.teamDataTracks = newTrackerPoll?.qotTeamToBeVisionTrackers
//                    guard let tracks = newTrackerPoll?.qotTeamToBeVisionTrackers else { return }
                    let tracks = ["we are the best", "we are great", "we listen"]
                    var remoteID = 344455
                    let questions = tracks.compactMap { (track) -> RatingQuestionViewModel.Question? in
//                        guard let remoteID = track.remoteID else { return nil }
//                        let question = track.sentence
                        remoteID = remoteID + 1
                        let question = track
                        let range = 10
                        return RatingQuestionViewModel.Question(remoteID: remoteID,
                                                                title: question,
                                                                htmlTitle: nil,
                                                                subtitle: nil,
                                                                dailyPrepTitle: nil,
                                                                key: nil,
                                                                answers: nil,
                                                                range: range,
                                                                selectedAnswerIndex: nil)
                    }
                    self.questions = questions
                    completion(questions)
                }
                return
//            }
        }
    }

    func addRating(for questionId: Int, value: Int, isoDate: Date) {
        let item = dataTracks?.filter { $0.remoteID == questionId }.first
        item?.addRating(value, isoDate: isoDate)
    }

    func saveQuestions() {
        guard let tracks = dataTracks else { return  }
        userService.updateToBeVisionTracks(tracks) { (error) in }
    }
}
