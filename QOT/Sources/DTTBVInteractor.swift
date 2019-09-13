//
//  DTTBVInteractor.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTTBVInteractor: DTInteractor {

    // MARK: - Properties
    private lazy var tbvWorker: DTShortTBVWorker? = DTShortTBVWorker()
}

// MARK: - DTTBVInteractorInterface
extension DTTBVInteractor: DTTBVInteractorInterface {}
