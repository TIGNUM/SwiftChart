//
//  MarkAsReadTableViewCell.swift
//  QOT
//
//  Created by karmic on 24.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MarkAsReadTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var markAsReadButton: RoundedButton!
    private var isRead = false
    weak var delegate: ArticleDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        ThemeBorder.accentBackground.apply(markAsReadButton)
    }

    func configure(selected: Bool) {
        isRead = selected
        let text = isRead ? AppTextService.get(AppTextKey.know_strategy_list_strategy_section_body_button_mark_as_unread) : AppTextService.get(AppTextKey.know_strategy_list_strategy_section_body_button_mark_as_read)
        ThemableButton.articleMarkAsRead(selected: !isRead).apply(markAsReadButton, title: text)
    }
}

// MARK: - Actions

extension MarkAsReadTableViewCell {
    @IBAction func didTapMarkAsReadButton() {
        delegate?.didTapMarkAsRead(!isRead)
    }
}
