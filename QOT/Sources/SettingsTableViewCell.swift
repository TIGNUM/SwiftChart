//
//  SettingsTableViewCell.swift
//  QOT
//
//  Created by karmic on 25.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SettingsTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Outlets / Properties

    @IBOutlet private weak var expandArrow: UIImageView!
    @IBOutlet private weak var bottomSeperatorView: UIView!
    @IBOutlet private weak var bottomSeperatorViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var switchControl: UISwitch!
    @IBOutlet private weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    private lazy var pickerItems = [String]()
    private lazy var selectedIndex = 0
    private lazy var indexPath = IndexPath(row: 0, section: 0)
    private lazy var settingsType = SettingsType.calendar
    private var calendarIdentifier: String?
    private var calendarSource: String?
    var controlUpdate = false
    var keyboardInputView: MyQotProfileSettingsKeybaordInputView?
    weak var settingsDelegate: SettingsViewControllerDelegate?
    weak var calendarSyncDelegate: SettingsCalendarListViewControllerDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        if bottomSeperatorView != nil {
            bottomSeperatorView.backgroundColor = .white15
            bottomSeperatorView.isHidden = true
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        accessoryType = .none
        if bottomSeperatorView != nil {
            bottomSeperatorView.isHidden = true
        }
    }

    // MARK: - Setup

    func setup(settingsRow: SettingsRow,
               indexPath: IndexPath,
               calendarIdentifier: String? = nil,
               calendarSource: String? = nil,
               isSyncFinished: Bool) {
        self.indexPath = indexPath
        self.calendarIdentifier = calendarIdentifier
        self.calendarSource = calendarSource
        self.bottomSeperatorView.isHidden = false
        switch settingsRow {
        case .button(let title, let value, let settingsType):
            self.settingsType = settingsType
            setupButtonCell(title: title, value: value)
        case .control(let title, let enabled, let settingsType, _, let source):
            self.settingsType = settingsType
            setupControlCell(title: title, source: source, isOn: enabled)
            setupControls(isSyncFinished: isSyncFinished)
        case .datePicker(let title, let selectedDate, let settingsType):
            self.settingsType = settingsType
            setupDateCell(title: title, selectedDate: selectedDate, settingsType: settingsType)
        case .label(let title, let value, let settingsType):
            if settingsType == .dateOfBirth,
                settingsType == .height,
                settingsType == .weight,
                settingsType == .gender {
                expandArrow.isHidden = false
            } else {
                expandArrow.isHidden = true
            }
            self.settingsType = settingsType
            self.bottomSeperatorView.isHidden = true
            setupTextFieldCell(title: title, value: value ?? "", settingsType: settingsType)
        case .stringPicker(let title, let pickerItems, let selectedIndex, let settingsType):
            self.settingsType = settingsType
            setupTextFieldCell(title: title, value: pickerItems[selectedIndex], settingsType: settingsType)
        case .multipleStringPicker(let title, let userMeasurement, _, let settingsType):
            self.settingsType = settingsType
            let displayableValue = userMeasurement.currentTitle()
            setupTextFieldCell(title: title, value: displayableValue, settingsType: settingsType)
        case .textField(let title, let value, _, let settingsType):
            self.settingsType = settingsType
            setupTextFieldCell(title: title, value: value, settingsType: settingsType)
        }
        if (settingsType == .calendar && settingsDelegate != nil) || settingsType == .adminSettings {
            accessoryType = .disclosureIndicator
        }
    }

    func setupHeaderCell(title: String) {
        setupLabelCell(title: title, value: nil)
    }

    func setupControls(isSyncFinished: Bool) {
        if isSyncFinished == true {
            switchControl.isHidden = false
            loadingIndicatorView.isHidden = true
            loadingIndicatorView.stopAnimating()
        } else {
            switchControl.isHidden = true
            loadingIndicatorView.isHidden = false
            loadingIndicatorView.startAnimating()
        }
        if self.settingsType == .calendarOnOtherDevices {
            switchControl.isHidden = true
        }
    }
}

// MARK: - Private

private extension SettingsTableViewCell {

    func setupButtonCell(title: String, value: String) {
        button.setAttributedTitle(Style.headlineSmall(title.uppercased()).attributedString(), for: .normal) //todo - lineSpacing: 2
        setValue(value: value)
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
        setTitle(title: title)
        setValue(value: source, alignment: .left)
    }

    func setupDateCell(title: String, selectedDate: Date, settingsType: SettingsType) {
        let date = DateFormatter.settingsUser.string(from: selectedDate)
        setupTextFieldCell(title: title, value: date, settingsType: settingsType)
    }

    func setupLabelCell(title: String, value: String?) {
        setValue(value: value)
        if value == nil {
            titleLabel.attributedText = NSMutableAttributedString(
                string: title.uppercased(),
                letterSpacing: 2,
                font: .H7Tag,
                lineSpacing: 4,
                textColor: .white60
            )
            valueLabel.isHidden = true
        } else {
            setTitle(title: title)
        }
    }

    func setupTextFieldCell(title: String, value: String, settingsType: SettingsType) {
        textField.text = value
        textField.delegate = self
        textField.keyboardType = .default
        textField.autocapitalizationType = UITextAutocapitalizationType.words
        setTitle(title: title)
		if settingsType == .phone {
            textField.autocapitalizationType = UITextAutocapitalizationType.none
			textField.keyboardType = .phonePad
		}
        textField.inputAccessoryView = keyboardInputView
    }

    private func separatorView(isEnabled: Bool) {
        bottomSeperatorView.backgroundColor = isEnabled ? .accent : .accent40
        bottomSeperatorViewHeightConstraint.constant = isEnabled ? 2.0 : 1.0
        if expandArrow != nil {
//            expandArrow.image = isEnabled ? R.image.arrowUp() : R.image.arrowDown()
        }
    }

	@objc func didFinishEnterText() {
		if let text = textField.text {
            separatorView(isEnabled: false)
			settingsDelegate?.didTextFieldEndEditing(at: indexPath, text: text)
		}
	}

    func setTitle(title: String) {
        titleLabel.text = title
        titleLabel.lineBreakMode = .byTruncatingTail
    }

    func setValue(value: String?, alignment: NSTextAlignment = .right) {
        guard let value = value, settingsType != .logout else {
            valueLabel.text = nil
            return
        }
        let theme: ThemeText
        switch settingsType {
        case .calendar, .calendarOnOtherDevices:
            theme = .settingsTitleFade
        default:
            theme = .settingsTitle
        }
        theme.apply(value, to: valueLabel)
    }
}

// MARK: - Actions

extension SettingsTableViewCell {

    @objc func valueChanged(sender: UISwitch) {
        switch settingsType {
        case .calendar: updateCalendarSettings(sender)
        case .strategies,
             .dailyPrep,
             .weeklyChoices: updateNotificationSettings(sender)
        default: return
        }
    }

    private func textFieldShouldReturn() -> Bool {
        textField.resignFirstResponder()
        return false
    }

    private func updateNotificationSettings(_ sender: UISwitch) {
        settingsDelegate?.didChangeNotificationValue(sender: sender, settingsCell: self, key: settingsType.notificationKey)
        setSwitchState(switchControl: sender)
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
    }
}

extension SettingsTableViewCell: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        separatorView(isEnabled: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            settingsDelegate?.didTextFieldChanged(at: indexPath, text: text)
        }
        return endEditing(true)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            settingsDelegate?.didTextFieldChanged(at: indexPath, text: updatedText)
        }
        return true
    }

	@objc func textFieldDidEndEditing(_ textField: UITextField) {
		didFinishEnterText()
	}
}
