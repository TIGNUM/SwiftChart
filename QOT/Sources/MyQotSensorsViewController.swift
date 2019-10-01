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
    @IBOutlet private weak var ouraRingStatusLabel: UILabel!
    @IBOutlet private weak var healthKitStatusLabel: UILabel!
    @IBOutlet private weak var sensorDescriptionLabel: UILabel!
    @IBOutlet private weak var sensorDescriptionHeaderabel: UILabel!
    @IBOutlet private weak var sensorHeaderLabel: UILabel!
    @IBOutlet private weak var healthKitNoDataInfoLabel: UILabel!
    @IBOutlet private weak var healthKitNoDataInfoHeightConstraint: NSLayoutConstraint!
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
        ThemeText.mySensorsNoDataInfoLabel.apply(ScreenTitleService.main.localizedString(for: .MyQotTrackerNoDataInfo),
                                                 to: healthKitNoDataInfoLabel)
        healthKitStatusButton.setTitle(status, for: .normal)
        healthKitStatusButton.isEnabled = buttonEnabled
        healthKitNoDataInfoHeightConstraint.constant = showNoDataInfo ? 30 : 0
    }

    func setOuraRing(title: String, status: String, labelStatus: String) {
        ouraRingStatusButton.setTitle(status, for: .normal)
        ThemeText.mySensorsDescriptionTitle.apply(title, to: ouraRingLabel)
    }

    func setSensor(title: String, description: String) {
        ThemeText.mySensorsDescriptionTitle.apply(title, to: sensorDescriptionHeaderabel)
        ThemeText.mySensorsDescriptionBody.apply(description, to: sensorDescriptionLabel)
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
