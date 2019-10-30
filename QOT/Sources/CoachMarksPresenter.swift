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
    func updateView(_ step: CoachMark.Step) {
        viewController?.updateView(createViewModel(step))
    }

    func setupView(_ step: CoachMark.Step) {
        viewController?.setupView(createViewModel(step))
    }
}

// MARK: - Private
private extension CoachMarksPresenter {
    func createViewModel(_ step: CoachMark.Step) -> CoachMark.ViewModel {
        return CoachMark.ViewModel(mediaName: step.media,
                                   title: step.title,
                                   subtitle: step.subtitle,
                                   rightButtonImage: step.rightButtonImage,
                                   hideBackButton: step.hideBackButton,
                                   page: step.rawValue)
    }
}
