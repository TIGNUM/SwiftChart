//
//  halloPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 07.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class halloPresenter {

    // MARK: - Properties
    private weak var viewController: halloViewControllerInterface?

    // MARK: - Init
    init(viewController: halloViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - halloInterface
extension halloPresenter: halloPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
