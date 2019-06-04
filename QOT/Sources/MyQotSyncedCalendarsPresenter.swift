//
//  MyQotSyncedCalendarsPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSyncedCalendarsPresenter {
    
    // MARK: - Properties
    
    private weak var viewController: MyQotSyncedCalendarsViewControllerInterface?
    
    // MARK: - Init
    
    init(viewController: MyQotSyncedCalendarsViewControllerInterface) {
        self.viewController = viewController
    }
}

extension MyQotSyncedCalendarsPresenter: MyQotSyncedCalendarsPresenterInterface {
    func setupView(with title: String) {
        viewController?.setupView(with: title)
    }
}
