//
//  MyVisionPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyVisionPresenter {

    private weak var viewController: MyVisionViewControllerInterface?
    private let options: [LaunchOption: String?]

    init(viewController: MyVisionViewControllerInterface, options: [LaunchOption: String?]? = nil) {
        self.viewController = viewController
        self.options = options ?? [:]
    }
}

extension MyVisionPresenter: MyVisionPresenterInterface {
    func showNullState(with title: String, message: String, writeMessage: String) {
        viewController?.showNullState(with: title, message: message, writeMessage: writeMessage)
    }

    func hideNullState() {
        viewController?.hideNullState()
    }

    func setupView() {
        viewController?.setupView()
    }

    func load(ratingView: TBVRatingView, myVision: QDMToBeVision?) {
        viewController?.load(ratingView: ratingView, myVision: myVision)
    }

    func presentTBVUpdateAlert(title: String, message: String, editTitle: String, crateNewTitle: String) {
        viewController?.presentTBVUpdateAlert(title: title,
                                              message: message,
                                              editTitle: editTitle,
                                              createNewTitle: crateNewTitle)
    }
}
