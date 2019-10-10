//
//  MyQotSensorsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotSensorsViewController: BaseViewController, ScreenZLevel3 {

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var ouraRingStatusButton: UIButton!
    @IBOutlet private weak var healthKitStatusButton: UIButton!
    @IBOutlet private weak var ouraRingLabel: UILabel!
    @IBOutlet private weak var healthKitLabel: UILabel!
    @IBOutlet private weak var healthKitDescriptionLabel: UILabel!
    @IBOutlet private weak var healthKitDescriptionHeaderabel: UILabel!
    @IBOutlet private weak var ouraRingDescriptionLabel: UILabel!
    @IBOutlet private weak var ouraRingDescriptionHeaderabel: UILabel!
    @IBOutlet private weak var sensorHeaderLabel: UILabel!
    @IBOutlet private weak var healthKitNoDataInfoLabel: UILabel!
    var interactor: MyQotSensorsInteractorInterface?
    var ouraRingAuthConfiguration: QDMOuraRingConfig?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateData),
                                               name: .requestSynchronization, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    @objc func didUpdateData() {
        interactor?.updateHealthKitStatus()
    }
}

extension MyQotSensorsViewController {
    @IBAction func ouraRingStatusButtonAction(_ sender: UIButton) {
        trackUserEvent(.SELECT, valueType: sender.titleLabel?.text, action: .TAP)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleOpenURL),
                                               name: .requestOpenUrl,
                                               object: nil)
        interactor?.requestAuraAuthorization()
    }

    @IBAction func healthKitStatusButtonAction(_ sender: UIButton) {
        trackUserEvent(.SELECT, valueType: sender.titleLabel?.text, action: .TAP)
        interactor?.requestHealthKitAuthorization()
    }
}

extension MyQotSensorsViewController: MyQotSensorsViewControllerInterface {
    func setupView() {
        ThemeView.level3.apply(view)
        ThemeButton.accent40.apply(healthKitStatusButton)
        ThemeButton.accent40.apply(ouraRingStatusButton)
    }

    func set(headerTitle: String, sensorTitle: String) {
        ThemeText.myQOTSectionHeader.apply(headerTitle, to: headerLabel)
        ThemeText.mySensorsTitle.apply(sensorTitle, to: sensorHeaderLabel)
    }

    func setHealthKit(title: String, status: String, showNoDataInfo: Bool, buttonEnabled: Bool) {
        ThemeText.mySensorsDescriptionTitle.apply(title, to: healthKitLabel)
        healthKitStatusButton.setTitle(status, for: .normal)
        healthKitStatusButton.isEnabled = buttonEnabled
    }

    func setOuraRing(title: String, status: String, labelStatus: String) {
        ouraRingStatusButton.setTitle(status, for: .normal)
        ThemeText.mySensorsDescriptionTitle.apply(title, to: ouraRingLabel)
    }

    func setHealthKitDescription(title: String, description: String, about: String) {
        ThemeText.mySensorsDescriptionTitle.apply(title, to: healthKitDescriptionHeaderabel)
        ThemeText.mySensorsDescriptionBody.apply(description, to: healthKitDescriptionLabel)
    }

    func setOuraRingDescription(title: String, description: String) {
        ThemeText.mySensorsDescriptionTitle.apply(title, to: ouraRingDescriptionHeaderabel)
        ThemeText.mySensorsDescriptionBody.apply(description, to: ouraRingDescriptionLabel)
    }
}

// MARK: - Private
private extension MyQotSensorsViewController {
    @objc func handleOpenURL(_ notification: Notification) {
        guard let url = notification.object as? URL, url.host == "oura-integration" else {
            presentedViewController?.dismiss(animated: true, completion: nil)
            return
        }
        interactor?.handleOuraRingAuthResultURL(url: url, ouraRingAuthConfiguration: ouraRingAuthConfiguration)
        NotificationCenter.default.removeObserver(self)
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
