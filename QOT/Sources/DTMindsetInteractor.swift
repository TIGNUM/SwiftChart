//
//  DTMindsetInteractor.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTMindsetInteractor: DTInteractor {

    // MARK: - Properties
    private lazy var mindsetWorker: DTMindsetWorker? = DTMindsetWorker()
}

extension DTMindsetInteractor: DTMindsetInteractorInterface {
    func getMindsetShifter(_ completion: @escaping (QDMMindsetShifter?) -> Void) {
        mindsetWorker?.getMindsetShifter(tbv: tbv, selectedAnswers: selectedAnswers, completion: completion)
    }

    func didDismissShortTBVScene(tbv: QDMToBeVision?) {
        self.tbv = tbv
    }

    func didDismissMindsetResults() {

    }
}
