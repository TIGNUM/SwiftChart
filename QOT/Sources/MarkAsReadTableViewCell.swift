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

    func configure(selected: Bool) {
        isRead = selected
        markAsReadButton.setAttributedTitle(attributed(selected: selected), for: .normal)
        markAsReadButton.backgroundColor = selected == true ? colorMode.tint.withAlphaComponent(0.3) : .clear
        markAsReadButton.corner(radius: 20)
        markAsReadButton.layer.borderColor = colorMode.tint.withAlphaComponent(0.3).cgColor
        markAsReadButton.layer.borderWidth = 1
    }

    func setMarkAsReadStatus(read: Bool) {
        isRead = read
        markAsReadButton.backgroundColor = read == true ? colorMode.tint.withAlphaComponent(0.3) : .clear
        markAsReadButton.setAttributedTitle(attributed(selected: read), for: .normal)
    }
}

// MARK: - Private

extension MarkAsReadTableViewCell {
    func attributed(selected: Bool) -> NSAttributedString {
        return NSAttributedString(string: selected == true ? "Mark as unread" : "Mark as read",
                                  letterSpacing: 0.4,
                                  font: .apercuMedium(ofSize: 12),
                                  textColor: colorMode.text.withAlphaComponent(0.6),
                                  alignment: .left)
    }
}

// MARK: - Actions

extension MarkAsReadTableViewCell {
    @IBAction func didTapMarkAsReadButton() {
        setMarkAsReadStatus(read: !isRead)
        delegate?.didTapMarkAsRead(isRead)
    }
}
