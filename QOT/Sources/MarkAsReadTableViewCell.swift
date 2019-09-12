//
//  MarkAsReadTableViewCell.swift
//  QOT
//
//  Created by karmic on 24.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MarkAsReadTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var markAsReadButton: UIButton!
    private var isRead = false
    weak var delegate: ArticleDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        ThemeBorder.accentBackground.apply(markAsReadButton)
    }

    func configure(selected: Bool) {
        isRead = selected

        let theme: ThemeView = selected ? ThemeView.articleMarkUnread : ThemeView.articleMarkRead
        theme.apply(markAsReadButton)

        let text = selected ? R.string.localized.markAsUnread() : R.string.localized.markAsRead()
        let attrText = ThemeText.articleMarkRead.attributedString(text)
        markAsReadButton.setAttributedTitle(attrText, for: .normal)
        markAsReadButton.setNeedsDisplay()
    }
}

// MARK: - Actions

extension MarkAsReadTableViewCell {
    @IBAction func didTapMarkAsReadButton() {
        delegate?.didTapMarkAsRead(!isRead)
    }
}
