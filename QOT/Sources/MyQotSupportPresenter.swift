//
//  MyQotSupportPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSupportPresenter {
    // MARK: - Properties
    
    private weak var viewController: MyQotSupportViewControllerInterface?
    
    // MARK: - Init
    
    init(viewController: MyQotSupportViewControllerInterface) {
        self.viewController = viewController
    }
}

extension MyQotSupportPresenter: MyQotSupportPresenterInterface {
    
    func setupView() {
        viewController?.setupView()
    }
}
