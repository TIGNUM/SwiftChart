//
//  MyQotSyncedCalendarCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotSyncedCalendarCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var switchControl: UISwitch!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    private var calendarIdentifier: String?
    private var calendarSource: String?
    private lazy var settingsType = SettingsType.calendar
    private lazy var indexPath = IndexPath(row: 0, section: 0)
    weak var calendarSyncDelegate: MyQotSyncedCalendarsViewControllerDelegate?

    // MARK: - Setup

    func setup(settingsRow: SettingsRow ,
               indexPath: IndexPath,
               calendarIdentifier: String? = nil,
               calendarSource: String? = nil,
               isSyncFinished: Bool) {
        switch settingsRow {
        case .control(let title, let enabled, let settingsType, _, let source):
                self.settingsType = settingsType
                setupControlCell(title: title, source: source, isOn: enabled)
                setupControls(isSyncFinished: isSyncFinished)
        default: return
        }
        self.indexPath = indexPath
        self.calendarIdentifier = calendarIdentifier
        self.calendarSource = calendarSource
    }

    func setupControls(isSyncFinished: Bool) {
        switchControl.isHidden = isSyncFinished == false || self.settingsType == .calendarOnOtherDevices
    }

    func setupControlCell(title: String, source: String?, isOn: Bool) {
        switchControl.isOn = isOn
        switchControl.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
        switchControl.tintColor = .white40
        switchControl.onTintColor = .clear
        switchControl.layer.borderWidth = 1
        switchControl.layer.borderColor = UIColor.white40.cgColor
        switchControl.layer.cornerRadius = 16
        setSwitchState(switchControl: switchControl)
        titleLabel.text = title.capitalized
        subtitleLabel.text = source
    }
}

// MARK: - Actions

extension MyQotSyncedCalendarCell {

    @objc func valueChanged(sender: UISwitch) {
        switch settingsType {
        case .calendar: updateCalendarSettings(sender)
        default: return
        }
    }

    private func updateCalendarSettings(_ sender: UISwitch) {
        if let calendarIdentifier = calendarIdentifier {
            calendarSyncDelegate?.didChangeCalendarSyncValue(sender: sender, calendarIdentifier: calendarIdentifier)
            setSwitchState(switchControl: sender)
        }
    }

    func setSwitchState(switchControl: UISwitch) {
        switchControl.alpha = switchControl.isOn == true ? 1 : 0.5
        if switchControl.isOn == true {
            switchControl.layer.addGlowEffect(color: .white, shadowRadius: 4)
        } else {
            switchControl.layer.removeGlowEffect()
        }
    }
}
