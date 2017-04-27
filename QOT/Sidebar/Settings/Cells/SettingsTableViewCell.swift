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
    @IBOutlet fileprivate weak var stringPickerView: UIPickerView!
    @IBOutlet fileprivate weak var datePicker: UIDatePicker!
    @IBOutlet fileprivate weak var button: UIButton!
    @IBOutlet fileprivate weak var textField: UITextField!
    fileprivate lazy var pickerItems = [String]()
    fileprivate lazy var selectedIndex = 0
    fileprivate lazy var indexPath = IndexPath(row: 0, section: 0)
    weak var delegate: SettingsViewControllerDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Setup

    func setup(settingsRow: SettingsRow, indexPath: IndexPath) {
        self.indexPath = indexPath

        switch settingsRow {
        case .button(let title, let value): setupButtonCell(title: title, value: value)
        case .control(let title, let enabled): setupControlCell(title: title, enabled: enabled)
        case .datePicker(let title, let selectedDate): setupDatePickerCell(title: title, selectedDate: selectedDate)
        case .label(let title, let value): setupLabelCell(title: title, value: value)
        case .stringPicker(let title, let pickerItems, let selectedIndex): setupStringPickerCell(title: title, pickerItems: pickerItems, selectedIndex: selectedIndex)
        case .textField(let title, let value, let secure): setupTextFieldCell(title: title, value: value, secure: secure)
        }
    }

    private func setupButtonCell(title: String, value: String) {
        button.setTitle(title, for: .normal)
    }

    private func setupControlCell(title: String, enabled: Bool) {
        titleLabel.text = title
        switchControl.isEnabled = enabled
        switchControl.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    private func setupDatePickerCell(title: String, selectedDate: Date) {
        titleLabel.text = title
        valueLabel.text = selectedDate.description(with: Locale.current)
        datePicker.setDate(selectedDate, animated: true)
        datePicker.isHidden = true
    }

    private func setupLabelCell(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }

    private func setupNavigationCell(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }

    private func setupStringPickerCell(title: String, pickerItems: [String], selectedIndex: Index) {
        self.selectedIndex = selectedIndex
        self.pickerItems = pickerItems
        titleLabel.text = title
        valueLabel.text = pickerItems[selectedIndex]
        stringPickerView.delegate = self
        stringPickerView.dataSource = self
        stringPickerView.isHidden = true
    }

    private func setupTextFieldCell(title: String, value: String, secure: Bool) {
        titleLabel.text = title
        textField.text = value
        textField.isSecureTextEntry = secure
    }
}

// MARK: - Actions

extension SettingsTableViewCell {

    func valueChanged(sender: UISwitch) {
        delegate?.didValueChanged(at: indexPath, enabled: sender.isEnabled)
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
