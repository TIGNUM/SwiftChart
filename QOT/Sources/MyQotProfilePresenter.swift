//
//  MyQotPresenter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotProfilePresenter {

    // MARK: - Properties

    private weak var viewController: MyQotProfileViewControllerInterface?

    // MARK: - Init

    init(viewController: MyQotProfileViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - MyQotInterface

extension MyQotProfilePresenter: MyQotProfilePresenterInterface {

    func setupView(profile: UserProfileModel, menuItems: [MyQotProfileModel.TableViewPresentationData]) {
        viewController?.setupView(profile: profile, menuItems: menuItems)
    }

    func showLoaderView() {
        viewController?.showLoaderView()
    }

    func hideLoaderView() {
        viewController?.hideLoaderView()
    }
}
