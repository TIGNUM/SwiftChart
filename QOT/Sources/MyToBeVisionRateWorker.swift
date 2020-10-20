//
//  MyToBeVisionRateWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyToBeVisionRateWorker: WorkerTeam {

    private let visionId: Int
    private var dataTracks: [QDMToBeVisionTrack]?
    private var votes = [QDMTeamToBeVisionTrackerVote]()
    private var trackerPoll: QDMTeamToBeVisionTrackerPoll?
    var questions: [RatingQuestionViewModel.Question]?
    var team: QDMTeam?

    init(visionId: Int) {
        self.visionId = visionId
        self.team = nil
    }

    init(trackerPoll: QDMTeamToBeVisionTrackerPoll?, team: QDMTeam?) {
        self.visionId = 0
        self.team = team
        self.trackerPoll = trackerPoll
    }

    func getQuestions(_ completion: @escaping (_ tracks: [RatingQuestionViewModel.Question]) -> Void) {
        if let team = team {
            getTeamQuestions(team: team, completion)
        } else {
            getPersonalQuestions(completion)
        }
    }

    func addRating(for questionId: Int, value: Int, isoDate: Date) {
        if team == nil {
            addPersonalRating(for: questionId, value: value, isoDate: isoDate)
        } else {
            addTeamReating(for: questionId, value: value, isoDate: isoDate)
        }
    }

    func saveQuestions() {
        if team == nil {
            savePersonalRating()
        } else {
            saveTeamRating()
        }
    }
}

// MARK: - Private
private extension MyToBeVisionRateWorker {
    func savePersonalRating() {
        guard let tracks = dataTracks else { return }
        UserService.main.updateToBeVisionTracks(tracks) { (error) in }
    }

    func saveTeamRating() {
        voteTeamToBeVisionTrackerPoll(votes) { [weak self] (poll) in
            self?.trackerPoll = poll
        }
    }

    func addPersonalRating(for questionId: Int, value: Int, isoDate: Date) {
        let item = dataTracks?.filter { $0.remoteID == questionId }.first
        item?.addRating(value, isoDate: isoDate)
    }

    // How to make QDMTeamToBeVisionTrackerVote intances
    // var votes = [QDMTeamToBeVisionTrackerVote]()
    // let poll: QDMTeamToBeVisionTrackerPoll = from some where
    // let vote = poll.qotTeamToBeVisionTrackers[index].voteWithRatingValue(9)
    // votes.append(vote)
    // If user tries to vote with already closed poll, it will return 'TeamToBeVisionTrakcerPollIsAlreadyClosed'
    // If user tries to vote on the poll which user alreay voted, it will return 'UserDidVoteTeamToBeVisionTrackerPoll'
    func addTeamReating(for questionId: Int, value: Int, isoDate: Date) {
        if let index = votes.firstIndex(where: { $0.remoteID == questionId }) {
            votes.remove(at: index)
        }
        let trackerResult = trackerPoll?.qotTeamToBeVisionTrackers?.filter { $0.remoteID == questionId }.first
        guard let vote = trackerResult?.voteWithRatingValue(value, isoDate) else { return }
        votes.append(vote)
    }

    func getPersonalQuestions(_ completion: @escaping (_ tracks: [RatingQuestionViewModel.Question]) -> Void) {
        UserService.main.getToBeVisionTracksForRating { [weak self] (tracks) in
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
    }

    func getTeamQuestions(team: QDMTeam,
                          _ completion: @escaping (_ tracks: [RatingQuestionViewModel.Question]) -> Void) {
        guard let tracks = trackerPoll?.qotTeamToBeVisionTrackers else {
            completion([])
            return
        }

        let questions = tracks.compactMap { (track) -> RatingQuestionViewModel.Question? in
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
        self.questions = questions
        completion(questions)
    }
}
