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
    private let viewController: MyToBeVisionRateViewController
    var questions: [RatingQuestionViewModel.Question]?
    var dataTracks: [QDMToBeVisionTrack]?

    init(visionId: Int, viewController: MyToBeVisionRateViewController) {
        self.visionId = visionId
        self.viewController = viewController
    }

    func getQuestions(_ completion: @escaping (_ tracks: [RatingQuestionViewModel.Question]) -> Void) {
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

    func addRating(for questionId: Int, value: Int, isoDate: Date) {
        let item = dataTracks?.filter { $0.remoteID == questionId }.first
        item?.addRating(value, isoDate: isoDate)
    }

    func saveQuestions() {
        guard let tracks = dataTracks else { return  }
        userService.updateToBeVisionTracks(tracks) { (error) in }
    }
}
