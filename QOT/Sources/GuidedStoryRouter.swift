//
//  GuidedStoryRouter.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class GuidedStoryRouter {

    // MARK: - Properties
    private weak var viewController: GuidedStoryViewController?
    private weak var surveyViewController: GuidedStorySurveyViewController?
    private let worker: GuidedStoryWorker!

    // MARK: - Init
    init(viewController: GuidedStoryViewController?, worker: GuidedStoryWorker) {
        self.viewController = viewController
        self.worker = worker
    }
}

// MARK: - GuidedStoryRouterInterface
extension GuidedStoryRouter: GuidedStoryRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func showSurvey() {
        if let survey = R.storyboard.guidedStory.surveyViCo() {
            GuidedStorySurveyConfigurator.make(viewController: survey, worker: worker)
            surveyViewController = survey
            surveyViewController?.delegate = viewController
            viewController?.add(survey, to: viewController?.viewContainer)
        }
    }

    func showJourney() {
        if let journey = R.storyboard.guidedStory.journeyViCo() {
            GuidedStoryJourneyConfigurator.make(viewController: journey)
            cycleFromViewController(from: surveyViewController, to: journey)
        }
    }
}

// MARK: - Private
private extension GuidedStoryRouter {
    func cycleFromViewController(from old: UIViewController?, to new: UIViewController?) {
        old?.willMove(toParent: nil)
        viewController?.add(new, to: viewController?.viewContainer)
        new?.view.alpha = 0
        new?.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.5) {
            new?.view.alpha = 1
            old?.view.alpha = 0
        } completion: { _ in
            old?.remove()
        }
    }
}
