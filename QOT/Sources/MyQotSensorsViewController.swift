//
//  MyQotSensorsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotSensorsViewController: UIViewController {

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
    @IBOutlet private weak var bottomNavigationView: BottomNavigationBarView!

    var interactor: MyQotSensorsInteractorInterface?

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
    }

    @IBAction func healthKitStatusButtonAction(_ sender: UIButton) {
        trackUserEvent(.SELECT, valueType: sender.titleLabel?.text, action: .TAP)
    }
}

extension MyQotSensorsViewController: MyQotSensorsViewControllerInterface {

    func setupView() {
        view.backgroundColor = .carbon
        bottomNavigationView.delegate = self
        healthKitStatusButton.corner(radius: Layout.CornerRadius.cornerRadius20.rawValue, borderColor: UIColor.accent30)
        ouraRingStatusButton.corner(radius: Layout.CornerRadius.cornerRadius20.rawValue, borderColor: UIColor.accent30)
    }

    func set(headerTitle: String, sensorTitle: String) {
        headerLabel.text = headerTitle
        sensorHeaderLabel.text = sensorTitle
    }

    func setHealthKit(title: String, status: String, labelStatus: String) {
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

extension MyQotSensorsViewController: BottomNavigationBarViewProtocol {
    func willNavigateBack() {
        trackUserEvent(.CLOSE, action: .TAP)
        navigationController?.popViewController(animated: true)
    }
}
