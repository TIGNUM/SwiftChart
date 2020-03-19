//
//  DTPrepareStartPresenter.swift
//  QOT
//
//  Created by karmic on 19.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class DTPrepareStartPresenter {

    // MARK: - Properties
    private weak var viewController: DTPrepareStartViewControllerInterface?

    // MARK: - Init
    init(viewController: DTPrepareStartViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - DTPrepareStartInterface
extension DTPrepareStartPresenter: DTPrepareStartPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
