//
//  DTShortTBVWorker.swift
//  QOT
//
//  Created by karmic on 10.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTShortTBVWorker: DTWorker {
    func createVision(selectedAnswers: [SelectedAnswer], completion: @escaping (QDMToBeVision?) -> Void) {
        let workIds = getSelectedIds(selectedAnswers, ShortTBV.QuestionKey.Work)
        let homeIds = getSelectedIds(selectedAnswers, ShortTBV.QuestionKey.Home)

        userService.generateToBeVisionWith(homeIds, workIds) { (vision, error) in
            if let error = error {
                log("Error generateToBeVisionWith: \(error.localizedDescription)", level: .error)
            }
            completion(vision)
        }
    }
}

private extension DTShortTBVWorker {
    func getSelectedIds(_ selectedAnswers: [SelectedAnswer], _ questionKey: String) -> [Int] {
        return selectedAnswers
            .filter { $0.question?.key == questionKey }
            .first?.answers
            .compactMap { $0.targetId(.content) } ?? []
    }
}
