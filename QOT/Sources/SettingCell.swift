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
        timePickerView.isHidden = isExpanded != true
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
