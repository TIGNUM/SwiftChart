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
    var questions: [MyToBeVisionRateViewModel.Question]?
    var dataTracks: [QDMToBeVisionTrack]?

    init(userService: qot_dal.UserService,
         visionId: Int,
         viewController: MyToBeVisionRateViewController) {
        self.userService = userService
        self.visionId = visionId
        self.viewController = viewController
    }

    func getQuestions(_ completion: @escaping (_ tracks: [MyToBeVisionRateViewModel.Question]?, _ initialized: Bool, _ error: Error?) -> Void) {
        userService.getToBeVisionTracksForRating {[weak self] (tracks, isInitialized, error) in
            let finalTracks = tracks?.filter({ $0.toBeVisionId == self?.visionId })
            self?.dataTracks = finalTracks
            let questions = finalTracks?.compactMap { (track) -> MyToBeVisionRateViewModel.Question? in
                guard let remoteID = track.remoteID else { return nil }
                let question = track.sentence
                let rating = track.ratings.sorted(by: { (ratingOne, ratingTwo) -> Bool in
                    guard let dateOne = ratingOne.isoDate, let dateTwo = ratingTwo.isoDate else {
                        return false
                    }
                    return dateOne.compare(dateTwo) == .orderedAscending
                }).first
                let range = 10
                let selectedAnswerIndex = (range - 1) / 2
                return MyToBeVisionRateViewModel.Question(remoteID: remoteID,
                                                          title: question ?? "",
                                                          subtitle: nil,
                                                          description: nil,
                                                          rating: rating?.rating ?? 0,
                                                          range: range,
                                                          answerIndex: selectedAnswerIndex)
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
