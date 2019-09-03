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

        markAsReadButton.setAttributedTitle(attributed(selected: selected), for: .normal)
        markAsReadButton.setNeedsDisplay()
    }
}

// MARK: - Private

extension MarkAsReadTableViewCell {
    func attributed(selected: Bool) -> NSAttributedString {
        let text = selected ? R.string.localized.markAsUnread() : R.string.localized.markAsRead()
        return ThemeText.articleMarkRead.attributedString(text)
    }
}

// MARK: - Actions

extension MarkAsReadTableViewCell {
    @IBAction func didTapMarkAsReadButton() {
        delegate?.didTapMarkAsRead(!isRead)
    }
}
