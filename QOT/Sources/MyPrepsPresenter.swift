//
//  MyPrepsPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyPrepsPresenter {

    // MARK: - Properties

    private weak var viewController: MyPrepsViewControllerInterface?
    private var myPrepsModel: MyPrepsModel?

    // MARK: - Init

    init(viewController: MyPrepsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - MyPrepsInterface

extension MyPrepsPresenter: MyPrepsPresenterInterface {

    func setupView() {
        viewController?.setupView()
    }

    func updateView() {
        viewController?.updateView()
    }
}
