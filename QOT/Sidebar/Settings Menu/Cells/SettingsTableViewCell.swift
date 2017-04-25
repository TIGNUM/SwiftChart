//
//  SettingsTableViewCell.swift
//  QOT
//
//  Created by karmic on 25.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Setup

    func setup(settingsRow: SettingsRow) {
        switch settingsRow {
        case .button(let title, let value): setupButtonCell(title: title, value: value)
        case .control(let title, let enabled): setupControlCell(title: title, enabled: enabled)
        case .datePicker(let title, let selectedDate): setupDatePickerCell(title: title, selectedDate: selectedDate)
        case .label(let title, let value): setupLabelCell(title: title, value: value)
        case .navigation(let title, let value): setupNavigationCell(title: title, value: value)
        case .stringPicker(let title, let pickerItems, let selectedIndex): setupStringPickerCell(title: title, pickerItems: pickerItems, selectedIndex: selectedIndex)
        case .textField(let title, let value, let secure): setupTextFieldCell(title: title, value: value, secure: secure)
        }
    }

    private func setupButtonCell(title: String, value: String) {

    }

    private func setupControlCell(title: String, enabled: Bool) {

    }

    private func setupDatePickerCell(title: String, selectedDate: Date) {

    }

    private func setupLabelCell(title: String, value: String) {

    }

    private func setupNavigationCell(title: String, value: String) {

    }

    private func setupStringPickerCell(title: String, pickerItems: [String], selectedIndex: Index) {

    }

    private func setupTextFieldCell(title: String, value: String, secure: Bool) {

    }
}
