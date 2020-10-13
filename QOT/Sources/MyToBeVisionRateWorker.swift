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

    private let userService = UserService.main
    private let visionId: Int
    private var teamRatings = [QDMTeamToBeVisionTrackerVote]()
    var questions: [RatingQuestionViewModel.Question]?
    var dataTracks: [QDMToBeVisionTrack]?
    var teamDataTracks: [QDMTeamToBeVisionTrackerResult]?
    var currentTrackerPoll: QDMTeamToBeVisionTrackerPoll?
    var team: QDMTeam?

    init(visionId: Int, team: QDMTeam?) {
        self.visionId = visionId
        self.team = team
    }

    func getQuestions(_ completion: @escaping (_ tracks: [RatingQuestionViewModel.Question]) -> Void) {
        if let team = team {
            getTeamQuestions(team: team, completion)
        } else {
            getPersonalQuestions(completion)
        }
    }
//        guard let team = team else {
////            Personal TBV
//        userService.getToBeVisionTracksForRating { [weak self] (tracks) in
//            guard let strongSelf = self else { return }
//            let finalTracks = tracks.filter { $0.toBeVisionId == strongSelf.visionId }
//            strongSelf.dataTracks = finalTracks
//
//            let questions = finalTracks.compactMap { (track) -> RatingQuestionViewModel.Question? in
//                guard let remoteID = track.remoteID else { return nil }
//                let question = track.sentence
//                let range = 10
//                return RatingQuestionViewModel.Question(remoteID: remoteID,
//                                                        title: question ?? "",
//                                                        htmlTitle: nil,
//                                                        subtitle: nil,
//                                                        dailyPrepTitle: nil,
//                                                        key: nil,
//                                                        answers: nil,
//                                                        range: range,
//                                                        selectedAnswerIndex: nil)
//            }
//            strongSelf.questions = questions
//            completion(questions)
//        }
//            return
//        }
//         Team TBV
//        TeamService.main.currentTeamToBeVisionTrackerPoll(for: team) { (trackerPoll, _, error) in
//            if let error = error {
//                log("Error currentTeamToBeVisionTrackerPoll \(error.localizedDescription)", level: .error)
//                // TODO handle error
//            }
//            // If there is no existing poll and I am the owner --> Open new Poll
//
//            if team.thisUserIsOwner, trackerPoll == nil {
//                TeamService.main.openNewTeamToBeVisionTrackerPoll(for: team) { (newTrackerPoll, _, error) in
//                    if let error = error {
//                        log("Error openNewTeamToBeVisionTrackerPoll \(error.localizedDescription)", level: .error)
//                        // TODO handle error
//                    }
//                    self.currentTrackerPoll = newTrackerPoll
//                    self.teamDataTracks = newTrackerPoll?.qotTeamToBeVisionTrackers
//                    // guard let tracks = newTrackerPoll?.qotTeamToBeVisionTrackers else { return }
//                    // Sending dummy data
//                    let tracks = ["We're simply the best", "Better than anyone", "Anyone I've ever known"]
//                    var remoteID = 344455
//                    let questions = tracks.compactMap { (track) -> RatingQuestionViewModel.Question? in
//                        //                        guard let remoteID = track.remoteID else { return nil }
//                        //                        let question = track.sentence
//                        remoteID = remoteID + 1
//                        let question = track
//                        let range = 10
//                        return RatingQuestionViewModel.Question(remoteID: remoteID,
//                                                                title: question,
//                                                                htmlTitle: nil,
//                                                                subtitle: nil,
//                                                                dailyPrepTitle: nil,
//                                                                key: nil,
//                                                                answers: nil,
//                                                                range: range,
//                                                                selectedAnswerIndex: nil)
//                    }
//                    self.questions = questions
//                    completion(questions)
//                }
//                return
            //                if I am the owner and there is an active rating poll or if I am a team Member --> Open current Poll
//
//            } else {
//                self.currentTrackerPoll = trackerPoll
//                self.teamDataTracks = trackerPoll?.qotTeamToBeVisionTrackers
//
//                guard let tracks = trackerPoll?.qotTeamToBeVisionTrackers else { return }
//                let questions = tracks.compactMap { (track) -> RatingQuestionViewModel.Question? in
//                    guard let remoteID = track.remoteID else { return nil }
//                    let question = track.sentence
//                    let range = 10
//                    return RatingQuestionViewModel.Question(remoteID: remoteID,
//                                                            title: question ?? "",
//                                                            htmlTitle: nil,
//                                                            subtitle: nil,
//                                                            dailyPrepTitle: nil,
//                                                            key: nil,
//                                                            answers: nil,
//                                                            range: range,
//                                                            selectedAnswerIndex: nil)
//                }
//                self.questions = questions
//                completion(questions)
//            }
//        }
//    }

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
        userService.updateToBeVisionTracks(tracks) { (error) in }
    }

    func saveTeamRating() {
        voteTeamToBeVisionTrackerPoll(teamRatings) { [weak self] (poll) in
            self?.currentTrackerPoll = poll
        }
    }

    func addPersonalRating(for questionId: Int, value: Int, isoDate: Date) {
        let item = dataTracks?.filter { $0.remoteID == questionId }.first
        item?.addRating(value, isoDate: isoDate)
    }

    // How to make QDMTeamToBeVisionTrackerVote intances
    // var vote = [QDMTeamToBeVisionTrackerVote]()
    // let poll: QDMTeamToBeVisionTrackerPoll = from some where
    // let vote = poll.qotTeamToBeVisionTrackers[index].voteWithRatingValue(9)
    // votes.append(vote)
    // If user tries to vote with already closed poll, it will return 'TeamToBeVisionTrakcerPollIsAlreadyClosed'
    // If user tries to vote on the poll which user alreay voted, it will return 'UserDidVoteTeamToBeVisionTrackerPoll'
    func addTeamReating(for questionId: Int, value: Int, isoDate: Date) {
        let item = teamDataTracks?.filter { $0.remoteID == questionId }.first
        guard let rate = item?.voteWithRatingValue(value) else { return }
        teamRatings.append(rate)
    }

    func getPersonalQuestions(_ completion: @escaping (_ tracks: [RatingQuestionViewModel.Question]) -> Void) {
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
    }

    func getTeamQuestions(team: QDMTeam,
                          _ completion: @escaping (_ tracks: [RatingQuestionViewModel.Question]) -> Void) {
        getCurrentRatingPoll(for: team) { [weak self] (poll) in
            self?.currentTrackerPoll = poll
            self?.teamDataTracks = poll?.qotTeamToBeVisionTrackers

            guard let tracks = poll?.qotTeamToBeVisionTrackers else {
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
            self?.questions = questions
            completion(questions)
        }
    }
}
