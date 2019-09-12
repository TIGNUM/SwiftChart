//
//  DTRecoveryInteractor.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTRecoveryInteractor: DTInteractor {

    override func getTitleToUpdate(selectedAnswers: [DTViewModel.Answer], questionKey: String?) -> String? {
        if questionKey == Recovery.QuestionKey.Symptom {
            return Recovery.getFatigueSymptom(selectedAnswers).replacement
        }
        return nil
    }
}

// MARK: - Private
private extension DTRecoveryInteractor {}

// MARK: - DTRecoveryInteractorInterface
extension DTRecoveryInteractor: DTRecoveryInteractorInterface {}
