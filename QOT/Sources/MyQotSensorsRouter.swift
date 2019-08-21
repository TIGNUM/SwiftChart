//
//  MyQotSensorsRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal
import SafariServices

final class MyQotSensorsRouter {

    // MARK: - Properties
    private weak var viewController: MyQotSensorsViewController?

    // MARK: - Init
    init(viewController: MyQotSensorsViewController) {
        self.viewController = viewController
    }
}

extension MyQotSensorsRouter: MyQotSensorsRouterInterface {
    func didTapSensor(sensor: MyQotSensorsModel, settingValue: SettingValue?, completion: @escaping (String) -> Void?) {
        switch sensor.sensor {
        case .oura: break
        case .healthKit: break
        case .requestTracker:
            presentAddSensorAlert(completion: {[weak self] text in
                completion(text)
                self?.viewController?.showAlert(type: .addSensorCompletion)
            })
        }
    }

    func startOuraAuth(requestURL: URL, config: QDMOuraRingConfig) {
        let safariVC = SFSafariViewController(url: requestURL)
        viewController?.present(safariVC, animated: true, completion: nil)
        viewController?.ouraRingAuthConfiguration = config
    }
}

// MARK: - Private
private extension MyQotSensorsRouter {
    func presentAddSensorAlert(completion: @escaping (String) -> Void) {
        let alert = UIViewController.alert(forType: .addSensor)
        alert.addAction(UIAlertAction(title: R.string.localized.addSensorViewAlertSend(),
                                      style: .default) { [unowned alert] _ in
                                        guard let text = alert.textFields?.first?.text, text.count > 0 else { return }
                                        completion(text)
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = R.string.localized.addSensorViewAlertPlaceholder()
        })
        viewController?.present(alert, animated: true)
    }
}
