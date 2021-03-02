//
//  CoachMarksPresenter.swift
//  QOT
//
//  Created by karmic on 22.10.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

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
    func updateView(_ presentationModel: [CoachMark.PresentationModel]) {
        let models = presentationModel.compactMap { createViewModel($0) }
        viewController?.updateView(models)
    }

    func setupView() {
        viewController?.setupView()
    }
}

// MARK: - Private
private extension CoachMarksPresenter {
    func createViewModel(_ presentationModel: CoachMark.PresentationModel) -> CoachMark.ViewModel {
        return CoachMark.ViewModel(mediaName: presentationModel.step.media,
                                   title: presentationModel.step.title,
                                   subtitle: presentationModel.step.subtitle,
                                   rightButtonTitle: presentationModel.step.rightButtonTitle,
                                   hideBackButton: presentationModel.step.hideBackButton,
                                   page: presentationModel.step.rawValue,
                                   isLastPage: presentationModel.step.isLastPage)
    }
}
