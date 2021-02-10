//
//  SettingCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.02.21.
//  Copyright © 2021 Tignum. All rights reserved.
//

import Foundation

final class SettingCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    weak var settingDelegate: DailyRemindersViewControllerDelegate?
    @IBOutlet weak var datePicker: UIDatePicker!
    var indexPath: IndexPath?
    var type: ReminderSetting.Setting?
    @IBOutlet weak var timePickerView: UIView!
    @IBOutlet weak var dayPickerView: UIView!
    var isExpanded: Bool?

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    // MARK: Configuration
    func configure(title: String?,
                   setting: String?,
                   isExpanded: Bool?,
                   type: ReminderSetting.Setting? ) {
        self.type = type
        self.isExpanded = isExpanded
        switch type {
        case.frequency:
            timePickerView.isHidden = isExpanded != true
        case .time:
            dayPickerView.isHidden = isExpanded != true
        default: break
        }
        if timePickerView.isHidden == false {
            datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        }
        ThemeText.syncedCalendarRowTitle.apply(title, to: titleLabel)
        settingButton.setTitle(setting, for: .normal)
    }

    @IBAction func datePickerChanged(_ sender: Any) {

    }
    @IBAction func settingTapped(_ sender: Any) {
        guard let settingDelegate = settingDelegate, let indexPath = indexPath else { return }
        settingDelegate.collapseSetting(self, didTapCollapseAt: indexPath)
    }
}

extension SettingCell: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "Monday"
        case 1:
            return "Tuesday"
        case 2:
            return "Wednesday"
        case 3:
            return "Thursday"
        case 4:
            return "Friday"
        case 5:
            return "Saturday"
        case 6:
            return "Sunday"
        default:
            return ""
        }
    }


}
