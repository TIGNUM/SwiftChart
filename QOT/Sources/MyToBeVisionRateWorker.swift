//
//  MyToBeVisionRateWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct DummyQuestion {
    let question: String
    let rating: Int
}

final class MyToBeVisionRateWorker {

    private let userService: qot_dal.UserService
    private let visionId: Int
    private let viewController: MyToBeVisionRateViewController
    var questions: [RatingQuestionViewModel.Question]?
    var dataTracks: [QDMToBeVisionTrack]?

    init(userService: qot_dal.UserService,
         visionId: Int,
         viewController: MyToBeVisionRateViewController) {
        self.userService = userService
        self.visionId = visionId
        self.viewController = viewController
    }

    func getQuestions(_ completion: @escaping (_ tracks: [RatingQuestionViewModel.Question]?, _ initialized: Bool, _ error: Error?) -> Void) {
        userService.getToBeVisionTracksForRating {[weak self] (tracks, isInitialized, error) in
            let finalTracks = tracks?.filter({ $0.toBeVisionId == self?.visionId })
            self?.dataTracks = finalTracks
            let questions = finalTracks?.compactMap { (track) -> RatingQuestionViewModel.Question? in
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
            completion(questions, isInitialized, error)
        }
    }

    func addRating(for questionId: Int, value: Int) {
        let item = dataTracks?.filter({ $0.remoteID == questionId }).first
        item?.addRating(value)
    }

    func saveQuestions() {
        guard let tracks = dataTracks else { return  }
        userService.updateToBeVisionTracks(tracks) { (error) in }
    }

    var skipCounterView: Bool {
        return UserDefaults.standard.bool(forKey: UserDefault.skipTBVCounter.rawValue)
    }

    func countDownView() -> UIView? {
        guard let vieController = R.storyboard.myToBeVisionRate.instantiateInitialViewController() else { return nil }
        MyToBeVisionCountDownConfigurator.configure(on: viewController, viewController: vieController)
        return vieController.view
    }
}
