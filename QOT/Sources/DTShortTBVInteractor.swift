//
//  DTShortTBVInteractor.swift
//  QOT
//
//  Created by karmic on 10.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTShortTBVInteractor: DTInteractor {

    // MARK: - Properties
    private lazy var shortTBVWorker: DTShortTBVWorker? = DTShortTBVWorker()
}

// MARK: - DTShortTBVInteractorInterface
extension DTShortTBVInteractor: DTShortTBVInteractorInterface {
    func generateTBV(_ completion: @escaping (String) -> Void) {
        shortTBVWorker?.createVision(selectedAnswers: selectedAnswers) { [weak self] (tbv) in
            self?.tbv = tbv
        }
    }
}
