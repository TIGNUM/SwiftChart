//
//  SensorRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 17/07/2018.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SensorRouter {

    // MARK: - Properties

    private let viewController: SensorViewController

    // MARK: - Init

    init(viewController: SensorViewController) {
        self.viewController = viewController
    }
}

// MARK: - SensorRouterInterface

extension SensorRouter: SensorRouterInterface {

    func didTapSensor(sensor: SensorModel, settingValue: SettingValue?, completion: @escaping (String) -> Void?) {
        switch sensor.sensor {
        case .fitbit:
            if sensor.state == .connected || sensor.state == .pending {
                guard let url = URL(string: "https://www.fitbit.com/user/profile/apps") else { return }
                presentSafariViewController(url: url)
            } else {
                presentFitbitWebView(settingValue: settingValue)
            }
        case .requestDevice:
            presentAddSensorAlert(completion: { text in
                completion(text)
                self.viewController.showAlert(type: .addSensorCompletion)
            })
        }
    }
}

// MARK: - Private

private extension SensorRouter {

    func presentSafariViewController(url: URL) {
        presentWebView(url: url)
    }

    func presentFitbitWebView(settingValue: SettingValue?) {
        if let value = settingValue, case .text(let urlString) = value, let url = URL(string: urlString) {
            presentWebView(url: url)
        }
    }

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
        viewController.present(alert, animated: true)
    }

    func presentWebView(url: URL) {
        do {
            let webViewController = try WebViewController(url)
            viewController.present(webViewController, animated: true)
            NotificationCenter.default.addObserver(viewController,
                                                   selector: #selector(viewController.reload),
                                                   name: .syncAllDidFinishNotification,
                                                   object: nil)
        } catch {
            log(error.localizedDescription, level: .error)
        }
    }
}
