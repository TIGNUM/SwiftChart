//
//  MyLibraryUserStoragePresenter.swift
//  QOT
//
//  Created by Sanggeon Park on 12.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyLibraryUserStoragePresenter {

    // MARK: - Properties

    private weak var viewController: MyLibraryUserStorageViewControllerInterface?

    // MARK: - Init

    init(viewController: MyLibraryUserStorageViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - MyLibraryBookmarksInterface

extension MyLibraryUserStoragePresenter: MyLibraryUserStoragePresenterInterface {

    func setupView() {
        viewController?.setupView()
    }

    func present() {
        viewController?.update()
    }

    func presentData() {
        viewController?.reloadData()
        present()
    }

    func deleteRow(at index: Int) {
        viewController?.deleteRow(at: IndexPath(row: index, section: .zero))
    }

    func presentAlert(title: String, message: String, buttons: [UIBarButtonItem]) {
        viewController?.presentAlert(title: title, message: message, buttons: buttons)
    }

    func presentNoInternetAlert() {
        viewController?.showNoInternetConnectionAlert()
    }
}
