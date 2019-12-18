//
//  MyQOTAdminChooseBucketsInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 18/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQOTAdminChooseBucketsInteractor {

    // MARK: - Properties
    private lazy var worker = MyQOTAdminChooseBucketsWorker()
    private let presenter: MyQOTAdminChooseBucketsPresenterInterface!

    // MARK: - Init
    init(presenter: MyQOTAdminChooseBucketsPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyQOTAdminChooseBucketsInteractorInterface
extension MyQOTAdminChooseBucketsInteractor: MyQOTAdminChooseBucketsInteractorInterface {
    func getHeaderTitle() -> String {
        return "DAILY CHECKIN BUCKETS"
    }
}
