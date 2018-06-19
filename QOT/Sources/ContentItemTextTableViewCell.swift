//
//  ContentItemTextTableViewCell.swift
//  QOT
//
//  Created by karmic on 05.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ContentItemTextTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Outlets

    @IBOutlet private weak var topLabel: ClickableLabel!
    @IBOutlet private weak var bottomLabel: ClickableLabel!
    weak var delegate: LearnContentItemViewController?

    func setup(topText: NSAttributedString,
               bottomText: NSAttributedString?,
               backgroundColor: UIColor = .white,
               delegate: ClickableLabelDelegate? = nil) {
        topLabel.delegate = delegate
        bottomLabel.delegate = delegate
        bottomLabel.isHidden = bottomText == nil
        topLabel.attributedText = topText
        bottomLabel.attributedText = bottomText
        contentView.backgroundColor = backgroundColor
        self.backgroundColor = backgroundColor
    }
}
