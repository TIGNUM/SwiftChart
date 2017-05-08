//
//  ImageSubtitleTableViewCell.swift
//  QOT
//
//  Created by tignum on 5/2/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ImageSubtitleTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Outlets

    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var label: UILabel!
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

    func setInsets(insets: UIEdgeInsets, spacing: CGFloat = 12) {
        topConstraint.constant = insets.top
        leadingConstraint.constant = insets.left
        trailingConstraint.constant = insets.right
        bottomConstraint.constant = insets.bottom
        stackView.spacing = spacing
    }

    func setupData(placeHolder: URL, description: NSAttributedString?) {
        label.isHidden = (description == nil)
        label.attributedText = description
        mainImageView.kf.indicatorType = .activity
        mainImageView.kf.setImage(with: placeHolder)
    }
}
