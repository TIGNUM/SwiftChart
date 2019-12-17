//
//  MyQotAdminLocalNotificationsInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminLocalNotificationsInteractor {

    // MARK: - Properties
    private lazy var worker = MyQotAdminLocalNotificationsWorker()
    private let presenter: MyQotAdminLocalNotificationsPresenterInterface!

    // MARK: - Init
    init(presenter: MyQotAdminLocalNotificationsPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyQotAdminLocalNotificationsInterface
extension MyQotAdminLocalNotificationsInteractor: MyQotAdminLocalNotificationsInteractorInterface {
}
