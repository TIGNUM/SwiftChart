//
//  QuestionPresenter.swift
//  
//
//  Created by Anais Plancoulaine on 21.06.19.
//

import UIKit

final class QuestionPresenter {

    // MARK: - Properties

    private weak var viewController: QuestionViewControllerInterface?

    // MARK: - Init

    init(viewController: QuestionViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - QuestionInterface

extension QuestionPresenter: QuestionPresenterInterface {
}
