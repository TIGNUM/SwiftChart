//
//  SettingsTableViewCell.swift
//  QOT
//
//  Created by karmic on 25.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Outlets / Properties

    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var valueLabel: UILabel!
    @IBOutlet fileprivate weak var switchControl: UISwitch!
    @IBOutlet fileprivate weak var button: UIButton!
    @IBOutlet fileprivate weak var textField: UITextField!
    fileprivate lazy var pickerItems = [String]()
    fileprivate lazy var selectedIndex = 0
    fileprivate lazy var indexPath = IndexPath(row: 0, section: 0)
    fileprivate lazy var settingsType = SettingsType.calendar
    fileprivate var calendarIdentifier: String?
    var controlUpdate = false
    weak var settingsDelegate: SettingsViewControllerDelegate?
    weak var calendarSyncDelegate: SettingsCalendarListViewControllerDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
    }

    // MARK: - Setup

    func setup(settingsRow: SettingsRow, indexPath: IndexPath, calendarIdentifier: String? = nil) {
        self.indexPath = indexPath
        self.calendarIdentifier = calendarIdentifier

        switch settingsRow {
        case .button(let title, let value, let settingsType):
            self.settingsType = settingsType
            setupButtonCell(title: title, value: value)
        case .control(let title, let enabled, let settingsType, _):
            self.settingsType = settingsType

            if settingsType == .location {
                let authorizationStatus = LocationManager.shared.authorizationStatus == .authorizedAlways || LocationManager.shared.authorizationStatus == .authorizedWhenInUse
                let enabled = authorizationStatus == true && UserDefault.locationService.boolValue == true
                setupControlCell(title: title, isOn: enabled)
            } else {                
                setupControlCell(title: title, isOn: enabled)
            }
        case .datePicker(let title, let selectedDate, let settingsType):
            self.settingsType = settingsType
            setupDateCell(title: title, selectedDate: selectedDate)
        case .label(let title, let value, let settingsType):
            self.settingsType = settingsType
            setupLabelCell(title: title, value: value)
        case .stringPicker(let title, let pickerItems, let selectedIndex, let settingsType):
            self.settingsType = settingsType
            setupLabelCell(title: title, value: pickerItems[selectedIndex])
        case .multipleStringPicker(let title, let rows, let initialSelection, let settingsType):
            self.settingsType = settingsType
            let valueIndex = initialSelection[0]
            let unitIndex = initialSelection[1]
            let displayableValue = String(format: "%@ %@", rows[0][valueIndex], rows[1][unitIndex])
            setupLabelCell(title: title, value: displayableValue)
        case .textField(let title, let value, let secure, let settingsType):
            self.settingsType = settingsType
            setupTextFieldCell(title: title, value: value, secure: secure)
        }

        if (settingsType == .calendar && settingsDelegate != nil) || settingsType == .password {
            accessoryType = .disclosureIndicator
        }
    }

    func setupHeaderCell(title: String) {
        setupLabelCell(title: title, value: nil)
    }
}

// MARK: - Private

private extension SettingsTableViewCell {

    func setupButtonCell(title: String, value: String) {
        button.setAttributedTitle(Style.headlineSmall(title.uppercased(), .white).attributedString(lineSpacing: 2), for: .normal)
        setValue(value: value)
    }

    func setupControlCell(title: String, isOn: Bool) {
        switchControl.isOn = isOn
        switchControl.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
        switchControl.tintColor = Color.whiteMedium
        switchControl.onTintColor = .clear
        switchControl.layer.borderWidth = 1
        switchControl.layer.borderColor = Color.whiteMedium.cgColor
        switchControl.layer.cornerRadius = 16
        setSwitchState(switchControl: switchControl)
        setTitle(title: title)
    }

    func setupDateCell(title: String, selectedDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        setupLabelCell(title: title, value: dateFormatter.string(from: selectedDate))
    }

    func setupLabelCell(title: String, value: String?) {
        setValue(value: value)
        if value == nil {
            titleLabel.attributedText = NSMutableAttributedString(
                string: title.uppercased(),
                letterSpacing: 2,
                font: Font.H7Tag,
                lineSpacing: 4,
                textColor: .white40
            )
            
            valueLabel.isHidden = true
        } else {
            setTitle(title: title)
        }
    }

    func setupTextFieldCell(title: String, value: String, secure: Bool) {
        textField.textColor = .white
        textField.text = value.uppercased()
        textField.isSecureTextEntry = secure
        setTitle(title: title)
    }

    func setTitle(title: String) {
        titleLabel.attributedText = Style.headlineSmall(title.uppercased(), .white).attributedString(lineSpacing: 2)
    }

    func setValue(value: String?) {
        guard let value = value else {
            valueLabel.text = nil
            return
        }
        
        valueLabel.attributedText = Style.tagTitle(value, .white40).attributedString(lineSpacing: 2, alignment: .right)
    }
}

// MARK: - Actions

extension SettingsTableViewCell {

    @objc func valueChanged(sender: UISwitch) {
        switch settingsType {
        case .location: updateLocationSettings(sender)
        case .calendar: updateCalendarSettings(sender)
        case .strategies,
             .dailyPrep,
             .weeklyChoices: updateNotificationSettings(sender)
        default: return
        }
    }

    private func updateNotificationSettings(_ sender: UISwitch) {
        settingsDelegate?.didChangeNotificationValue(sender: sender, settingsCell: self, key: settingsType.notificationKey)
        setSwitchState(switchControl: sender)
    }

    private func updateLocationSettings(_ sender: UISwitch) {
        if controlUpdate == false {
            controlUpdate = true
            settingsDelegate?.didChangeLocationValue(sender: sender, settingsCell: self)
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

    @IBAction private func didTapButton(sender: UIButton) {
        settingsDelegate?.didTapButton(at: indexPath, settingsType: .calendar)
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension SettingsTableViewCell: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItems.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {        
        return pickerItems[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = pickerItems[row]
        valueLabel.text = selectedValue
        selectedIndex = row
        settingsDelegate?.didTapPickerCell(at: indexPath, selectedValue: selectedValue)
    }
}
