//
//  MyLibraryNotesPresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyLibraryNotesPresenter {

    // MARK: - Properties

    private weak var viewController: MyLibraryNotesViewControllerInterface?

    // MARK: - Init

    init(viewController: MyLibraryNotesViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - MyLibraryNotesInterface

extension MyLibraryNotesPresenter: MyLibraryNotesPresenterInterface {
    func present() {
        viewController?.update()
    }

    func continueEditing() {
        viewController?.beginEditing()
    }

    func presentAlert(title: String?, message: String?, buttons: [UIBarButtonItem]) {
        viewController?.showAlert(title: title, message: message, buttons: buttons)
    }
}
