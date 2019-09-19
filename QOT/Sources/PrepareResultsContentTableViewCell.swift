//
//  PrepareResultsContentTableViewCell.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class PrepareResultsContentTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var headerMark: UIView!
    @IBOutlet private weak var bottomSeperator: UIView!
    @IBOutlet private weak var listMark: UIView!
    @IBOutlet private weak var editImageView: UIImageView!
    @IBOutlet private weak var constraintTop: NSLayoutConstraint!
    @IBOutlet private weak var constraintBottom: NSLayoutConstraint!

    func configure(_ format: ContentFormat, title: String?, type: QDMUserPreparation.Level) {
        titleLabel.attributedText = format.attributedText(title: title)
        headerMark.isHidden = !format.hasHeaderMark
        listMark.isHidden = !format.hasListMark
        bottomSeperator.isHidden = !format.hasBottomSeperator(type)
        editImageView.isHidden = !format.hasEditImage(type)

        selectionStyle = editImageView.isHidden ? .none : .default

        let margin: CGFloat = format.isTitle ? 23 : 8
        constraintTop.constant = margin
        constraintBottom.constant = margin 
    }
}
