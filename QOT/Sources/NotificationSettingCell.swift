//
//  NotificationSettingCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 04.02.21.
//  Copyright © 2021 Tignum. All rights reserved.
//

import Foundation

final class NotificationSettingCell: UITableViewCell, Dequeueable {
    @IBOutlet private weak var switchControl: UISwitch!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    private var identifier: String?

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        switchControl.corner(radius: Layout.cornerRadius08*2, borderColor: .clear)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        switchControl.alpha = 1.0
        isUserInteractionEnabled = true
    }

    // MARK: Configuration
    func configure(title: String?,
                   subtitle: String?,
                   isActive: Bool?) {

        ThemeText.syncedCalendarRowTitle.apply(title, to: titleLabel)
        ThemeText.syncedCalendarRowSubtitle.apply(subtitle, to: subtitleLabel)

        if isActive == true {
            switchControl.isOn = false
            isUserInteractionEnabled = false
//            switchControl.alpha = 0.1
        }
    }
}

// MARK: - Actions
extension NotificationSettingCell {
//    @IBAction func valueChanged(_ sender: UISwitch) {
//        if let identifier = identifier {
//            calendarSyncDelegate?.didChangeCalendarSyncValue(enabled: sender.isOn, identifier: identifier)
//        }
//    }
}

