//
//  SyncedCalendarCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class SyncedCalendarCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    weak var calendarSyncDelegate: SyncedCalendarsViewControllerDelegate?
    @IBOutlet private weak var switchControl: UISwitch!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    private var identifier: String?

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        switchControl.corner(radius: Layout.cornerRadius08*2, borderColor: .accent40)
    }

    // MARK: Configuration
    func configure(title: String?,
                   source: String?,
                   syncEabled: Bool?,
                   identifier: String?,
                   isSubscribed: Bool?,
                   switchIsHidden: Bool?) {
        switchControl.isHidden = switchIsHidden ?? true
        switchControl.isOn = syncEabled ?? false

        ThemeText.syncedCalendarRowTitle.apply(title, to: titleLabel)
        ThemeText.syncedCalendarRowSubtitle.apply(source, to: subtitleLabel)
        self.identifier = identifier

        if isSubscribed == true {
            switchControl.isOn = false
            isUserInteractionEnabled = false
            if let title = title {
                ThemeText.syncedCalendarRowSubtitle.apply(title + "*", to: titleLabel)
            }
            switchControl.alpha = 0.1
        }
    }
}

// MARK: - Actions
extension SyncedCalendarCell {
    @IBAction func valueChanged(_ sender: UISwitch) {
        if let identifier = identifier {
            calendarSyncDelegate?.didChangeCalendarSyncValue(enabled: sender.isOn, identifier: identifier)
        }
    }
}
