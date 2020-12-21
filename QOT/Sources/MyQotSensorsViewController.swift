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

    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var ouraRingStatusButton: RoundedButton!
    @IBOutlet private weak var healthKitStatusButton: RoundedButton!
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
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        interactor?.viewDidLoad()
        _ = NotificationCenter.default.addObserver(forName: .requestSynchronization,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.didUpdateData()
        }
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
        _ = NotificationCenter.default.addObserver(forName: .requestOpenUrl,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.handleOpenURL(notification)
        }
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
        ThemeButton.darkButton.apply(ouraRingStatusButton)
        ThemeButton.darkButton.apply(healthKitStatusButton)
    }

    func set(headerTitle: String, sensorTitle: String) {
        baseHeaderView?.configure(title: headerTitle, subtitle: nil)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0
        ThemeText.mySensorsTitle.apply(sensorTitle, to: sensorHeaderLabel)
    }

    func setHealthKit(title: String, status: String, showNoDataInfo: Bool) {
        ThemeText.mySensorsDescriptionTitle.apply(title, to: healthKitLabel)
        ThemableButton.darkButton.apply(healthKitStatusButton, title: title)
    }

    func setOuraRing(title: String, status: String, labelStatus: String) {
        ThemableButton.darkButton.apply(ouraRingStatusButton, title: title)
        ThemeText.mySensorsDescriptionTitle.apply(title, to: ouraRingLabel)
    }

    func setHealthKitDescription(title: String, description: String) {
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
