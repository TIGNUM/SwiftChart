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
    weak var delegate: SettingsViewControllerDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
    }

    // MARK: - Setup

    func setup(settingsRow: SettingsRow, indexPath: IndexPath) {
        self.indexPath = indexPath

        switch settingsRow {
        case .button(let title, let value): setupButtonCell(title: title, value: value)
        case .control(let title, let enabled): setupControlCell(title: title, isOn: enabled)
        case .datePicker(let title, let selectedDate): setupDateCell(title: title, selectedDate: selectedDate)
        case .label(let title, let value): setupLabelCell(title: title, value: value)
        case .stringPicker(let title, let pickerItems, let selectedIndex): setupLabelCell(title: title, value: pickerItems[selectedIndex])
        case .textField(let title, let value, let secure): setupTextFieldCell(title: title, value: value, secure: secure)
        }
    }

    func setupHeaderCell(title: String) {
        setupLabelCell(title: title, value: nil)
    }
}

// MARK: - Private

private extension SettingsTableViewCell {

    func setupButtonCell(title: String, value: String) {
        button.setAttributedTitle(Style.headlineSmall(title.uppercased(), .white40).attributedString(lineSpacing: 2), for: .normal)
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
            titleLabel.attributedText = Style.paragraph(title.uppercased(), .white40).attributedString(lineSpacing: 2)
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
        titleLabel.attributedText = Style.paragraph(title.uppercased(), .white40).attributedString(lineSpacing: 2)
    }

    func setValue(value: String?) {
        guard let value = value else {
            valueLabel.text = nil
            return
        }

        valueLabel.attributedText = Style.paragraph(value.uppercased(), .white40).attributedString(lineSpacing: 2)
    }
}

// MARK: - Actions

extension SettingsTableViewCell {

    func valueChanged(sender: UISwitch) {
        delegate?.didValueChanged(at: indexPath, enabled: sender.isEnabled)
        setSwitchState(switchControl: sender)
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
        delegate?.didTapButton(at: indexPath)
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
        delegate?.didTapPickerCell(at: indexPath, selectedValue: selectedValue)
    }
}
