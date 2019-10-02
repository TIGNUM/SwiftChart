//
//  DTSprintReflectionViewController.swift
//  QOT
//
//  Created by Michael Karbe on 17.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTSprintReflectionViewController: DTViewController {

    // MARK: - Properties
    var sprintInteractor: DTSprintReflectionInteractorInterface?
    private lazy var sprintRouter: DTSprintReflectionRouterInterface? = DTSprintReflectionRouter(viewController: self)

    // MARK: - Init
    init(configure: Configurator<DTSprintReflectionViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - DTQuestionnaireViewControllerDelegate
    override func didTapBinarySelection(_ answer: DTViewModel.Answer) {
        sprintInteractor?.updateSprint()
        switch answer.keys.first {
        case SprintReflection.AnswerKey.DoItLater:
            router?.dismiss()
        case SprintReflection.AnswerKey.TrackTBV:
            sprintRouter?.presentTrackTBV()
        default:
            return
        }
    }
}

// MARK: - Private
private extension DTSprintReflectionViewController {}

// MARK: - DTSprintReflectionViewControllerInterface
extension DTSprintReflectionViewController: DTSprintReflectionViewControllerInterface {}
