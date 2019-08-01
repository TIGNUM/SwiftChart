//
//  MySprintNotesPresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MySprintNotesPresenter {

    // MARK: - Properties

    private weak var viewController: MySprintNotesViewControllerInterface?

    // MARK: - Init

    init(viewController: MySprintNotesViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - MySprintNotesInterface

extension MySprintNotesPresenter: MySprintNotesPresenterInterface {
    func present() {
        viewController?.update()
    }

    func continueEditing() {
        viewController?.beginEditing()
    }
}
