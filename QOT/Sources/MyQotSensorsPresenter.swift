//
//  MyQotSensorsPresenter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSensorsPresenter {

    // MARK: - Properties
    private weak var viewController: MyQotSensorsViewControllerInterface?

    // MARK: - Init
    init(viewController: MyQotSensorsViewControllerInterface) {
        self.viewController = viewController
    }
}

extension MyQotSensorsPresenter: MyQotSensorsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func set(headerTitle: String, sensorTitle: String) {
        viewController?.set(headerTitle: headerTitle, sensorTitle: sensorTitle)
    }

    func setHealthKit(title: String, status: String, showNoDataInfo: Bool, buttonEnabled: Bool) {
        viewController?.setHealthKit(title: title,
                                     status: status,
                                     showNoDataInfo: showNoDataInfo,
                                     buttonEnabled: buttonEnabled)
    }

    func setOuraRing(title: String, status: String, labelStatus: String) {
        viewController?.setOuraRing(title: title, status: status, labelStatus: labelStatus)
    }

    func setHealthKitDescription(title: String, description: String) {
        viewController?.setHealthKitDescription(title: title, description: description)
    }

    func setOuraRingDescription(title: String, description: String) {
        viewController?.setOuraRingDescription(title: title, description: description)
    }
}
