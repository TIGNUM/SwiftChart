//
//  DTTBVInteractor.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTTBVInteractor: DTInteractor {

    // MARK: - Properties
    private lazy var tbvWorker: TBVWorker? = TBVWorker()
    private var tbv: QDMToBeVision?

    override func getTBV(questionAnswerType: String?) -> QDMToBeVision? {
        if questionAnswerType == AnswerType.text.rawValue || questionAnswerType == AnswerType.noAnswerRequired.rawValue {
            return tbv
        }
        return nil
    }
}

// MARK: - DTTBVInteractorInterface
extension DTTBVInteractor: DTTBVInteractorInterface {
    func generateTBV(selectedAnswers: [SelectedAnswer],
                     questionKeyWork: String,
                     questionKeyHome: String,
                     _ completion: @escaping (QDMToBeVision?) -> Void) {
        tbvWorker?.createVision(selectedAnswers: selectedAnswers,
                                questionKeyWork: TBV.QuestionKey.Work,
                                questionKeyHome: TBV.QuestionKey.Home,
                                shouldSave: true) { [weak self] (tbv) in
            self?.tbv = tbv
            completion(tbv)
        }
    }

    func saveTBVImage(_ image: UIImage) {
        tbvWorker?.save(image)
    }
}
