//
//  CoachMarksPresenter.swift
//  QOT
//
//  Created by karmic on 22.10.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class CoachMarksPresenter {

    // MARK: - Properties
    private weak var viewController: CoachMarksViewControllerInterface?    

    // MARK: - Init
    init(viewController: CoachMarksViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - CoachMarksInterface
extension CoachMarksPresenter: CoachMarksPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
