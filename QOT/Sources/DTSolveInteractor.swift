//
//  DTSolveInteractor.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTSolveInteractor: DTInteractor {
    override func getTBV(questionAnswerType: String?, questionKey: String?) -> QDMToBeVision? {
        if questionAnswerType == AnswerType.text.rawValue {
            return tbv
        }
        return nil
    }
}

// MARK: - DTShortTBVDelegate
extension DTSolveInteractor: DTShortTBVDelegate {
    func didDismissShortTBVScene(tbv: QDMToBeVision?) {
        self.tbv = tbv
    }
}
