//
//  DecisionTreePresenter.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

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

    func load(_ decisionTree: DecisionTreeModel) {
        viewController?.load(decisionTree)
    }

    func presentNext(_ question: Question, with extraAnswer: String?) {
        viewController?.loadNext(question, with: extraAnswer)
    }
}
