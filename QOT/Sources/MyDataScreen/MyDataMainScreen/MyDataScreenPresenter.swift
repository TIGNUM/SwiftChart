//
//  MyDataScreenPresenter.swift
//  
//
//  Created by Simu Voicu-Mircea on 19/08/2019.
//  Copyright (c) 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit

final class MyDataScreenPresenter {

    // MARK: - Properties
    private weak var viewController: MyDataScreenViewControllerInterface?

    // MARK: - Init
    init(viewController: MyDataScreenViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - MyDataScreenInterface
extension MyDataScreenPresenter: MyDataScreenPresenterInterface {
    func present(for myDataSection: MyDataScreenModel) {
        viewController?.setup(for: myDataSection)
    }
    
    func setupView() {
        viewController?.setupView()
    }
}
