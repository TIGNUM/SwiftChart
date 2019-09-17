//
//  DTShortTBVInteractor.swift
//  QOT
//
//  Created by karmic on 10.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTShortTBVInteractor: DTInteractor {

    // MARK: - Properties
    private lazy var tbvWorker: TBVWorker? = TBVWorker()
    private var tbv: QDMToBeVision?

    override func getTBV(questionAnswerType: String?, questionKey: String?) -> QDMToBeVision? {
        if questionAnswerType == AnswerType.text.rawValue || questionAnswerType == AnswerType.noAnswerRequired.rawValue {
            return tbv
        }
        return nil
    }
}

// MARK: - DTShortTBVInteractorInterface
extension DTShortTBVInteractor: DTShortTBVInteractorInterface {
    var canGoBack: Bool {
        return presentedNodes.isEmpty == false
    }

    func getTBV() -> QDMToBeVision? {
        return tbv
    }

    func generateTBV(selectedAnswers: [SelectedAnswer],
                     questionKeyWork: String,
                     questionKeyHome: String,
                     _ completion: @escaping (QDMToBeVision?) -> Void) {
        tbvWorker?.createVision(selectedAnswers: selectedAnswers,
                                questionKeyWork: ShortTBV.QuestionKey.Work,
                                questionKeyHome: ShortTBV.QuestionKey.Home) { [weak self] (tbv) in
                                    self?.tbv = tbv
                                    completion(tbv)
        }
    }
}
