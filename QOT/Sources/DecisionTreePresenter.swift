//
//  DecisionTreePresenter.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DecisionTreePresenter {

    // MARK: - Properties
    private weak var viewController: DecisionTreeViewControllerInterface?

    // MARK: - Init
    init(viewController: DecisionTreeViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - DecisionTreeInterface
extension DecisionTreePresenter: DecisionTreePresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func showQuestion(_ question: QDMQuestion,
                      extraAnswer: String?,
                      filter: String?,
                      selectedAnswers: [DecisionTreeModel.SelectedAnswer],
                      direction: UIPageViewController.NavigationDirection,
                      animated: Bool) {
        viewController?.showQuestion(question,
                                     extraAnswer: extraAnswer,
                                     filter: filter,
                                     selectedAnswers: selectedAnswers,
                                     direction: direction,
                                     animated: animated)
    }

    func trackUserEvent(_ answer: QDMAnswer?,
                        _ name: QDMUserEventTracking.Name,
                        _ valueType: QDMUserEventTracking.ValueType?) {
        viewController?.trackUserEvent(answer, name, valueType)
    }

    func dismiss() {
        viewController?.dismiss()
    }

    func presentAddEventController(_ eventStore: EKEventStore) {
        viewController?.presentAddEventController(eventStore)
    }

    func presentInfoView(icon: UIImage?, title: String?, text: String?) {
        viewController?.presentInfoView(icon: icon, title: title, text: text)
    }

    func toBeVisionDidChange() {
        viewController?.toBeVisionDidChange()
    }
}
