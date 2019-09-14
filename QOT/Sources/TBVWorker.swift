//
//  TBVWorker.swift
//  QOT
//
//  Created by karmic on 14.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

class TBVWorker {

    // MARK: - Properties
    private lazy var userService = UserService.main

    func createVision(selectedAnswers: [SelectedAnswer],
                      questionKeyWork: String,
                      questionKeyHome: String,
                      completion: @escaping (QDMToBeVision?) -> Void) {
        let workIds = getSelectedIds(selectedAnswers, questionKeyWork)
        let homeIds = getSelectedIds(selectedAnswers, questionKeyHome)

        userService.generateToBeVisionWith(homeIds, workIds) { (vision, error) in
            if let error = error {
                log("Error generateToBeVisionWith: \(error.localizedDescription)", level: .error)
            }
            completion(vision)
        }
    }

    func getUsersTBV(_ completion: @escaping (QDMToBeVision?, Bool) -> Void) {
        userService.getMyToBeVision { (tbv, initiated, error) in
            if let error = error {
                log("Error getMyToBeVision: \(error.localizedDescription)", level: .error)
            }
            completion(tbv, initiated)
        }
    }

    // MARK: - Helper
    func getSelectedIds(_ selectedAnswers: [SelectedAnswer], _ questionKey: String) -> [Int] {
        return selectedAnswers
            .filter { $0.question?.key == questionKey }
            .first?.answers
            .compactMap { $0.targetId(.content) } ?? []
    }
}
