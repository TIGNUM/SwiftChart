//
//  SideBarViewCell.swift
//  QOT
//
//  Created by tignum on 4/28/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

final class SideBarTextCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak  var textTitleLabel: UILabel!
    @IBOutlet private weak var mainTextLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    func setUp(title: NSAttributedString, text: NSAttributedString) {
        textTitleLabel.attributedText = title
        mainTextLabel.attributedText = text
    }

    func setInsets(insets: UIEdgeInsets, spacing: CGFloat = 12) {
        topConstraint.constant = insets.top
        leadingConstraint.constant = insets.left
        trailingConstraint.constant = insets.right
        bottomConstraint.constant = insets.bottom
        stackView.spacing = spacing
    }
}
