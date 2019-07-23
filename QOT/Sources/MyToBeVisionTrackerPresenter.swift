//
//  MyToBeVisionTrackerPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 04.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyToBeVisionTrackerPresenter {

    // MARK: - Properties

    private weak var viewController: MyToBeVisionTrackerViewControllerInterface?

    // MARK: - Init

    init(viewController: MyToBeVisionTrackerViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - MyToBeVisionTrackerInterface

extension MyToBeVisionTrackerPresenter: MyToBeVisionTrackerPresenterInterface {
    func setupView(with data: MYTBVDataViewModel) {
        viewController?.setupView(with: data)
    }
}
