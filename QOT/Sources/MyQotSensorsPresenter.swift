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
    
    func set(headerTitle: String, sensorTitle: String,  requestTrackerTitle: String) {
        viewController?.set(headerTitle: headerTitle, sensorTitle: sensorTitle,  requestTrackerTitle: requestTrackerTitle)
    }
    
    func setHealthKit(title: String, status: String, labelStatus: String) {
        viewController?.setHealthKit(title: title, status: status, labelStatus: labelStatus)
    }

    func setOuraRing(title: String, status: String, labelStatus: String) {
        viewController?.setOuraRing(title: title, status: status, labelStatus: labelStatus)
    }
    
    func setSensor(title: String, description: String) {
        viewController?.setSensor(title: title, description: description)
    }
}
