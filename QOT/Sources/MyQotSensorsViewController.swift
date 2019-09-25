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
    @IBOutlet private weak var requestActivityTrackerLabel: UILabel!
    @IBOutlet private weak var sensorHeaderLabel: UILabel!
    var interactor: MyQotSensorsInteractorInterface?
    var ouraRingAuthConfiguration: QDMOuraRingConfig?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
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
        healthKitStatusButton.corner(radius: Layout.CornerRadius.cornerRadius20.rawValue, borderColor: .accent30)
        ouraRingStatusButton.corner(radius: Layout.CornerRadius.cornerRadius20.rawValue, borderColor: .accent30)
    }

    func set(headerTitle: String, sensorTitle: String) {
        ThemeText.myQOTSectionHeader.apply(headerTitle, to: headerLabel)
        sensorHeaderLabel.text = sensorTitle
    }

    func setHealthKit(title: String, status: String, labelStatus: String, buttonEnabled: Bool) {
        healthKitStatusButton.isEnabled = buttonEnabled
        healthKitStatusButton.setTitle(status, for: .normal)
        healthKitLabel.text = title
        healthKitStatusLabel.text = labelStatus
    }

    func setOuraRing(title: String, status: String, labelStatus: String) {
        ouraRingStatusButton.setTitle(status, for: .normal)
        ouraRingLabel.text = title
        ouraRingStatusLabel.text = labelStatus
    }

    func setSensor(title: String, description: String) {
        sensorDescriptionHeaderabel.text = title
        sensorDescriptionLabel.setAttrText(text: description, font: .sfProtextRegular(ofSize: FontSize.fontSize14))
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
