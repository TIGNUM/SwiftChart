//
//  MarkAsReadTableViewCell.swift
//  QOT
//
//  Created by karmic on 24.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

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

        let text = selected ? R.string.localized.markAsUnread() : R.string.localized.markAsRead()
        ThemableButton.articleMarkAsRead.apply(markAsReadButton, title: text)
    }
}

// MARK: - Actions

extension MarkAsReadTableViewCell {
    @IBAction func didTapMarkAsReadButton() {
        delegate?.didTapMarkAsRead(!isRead)
    }
}
