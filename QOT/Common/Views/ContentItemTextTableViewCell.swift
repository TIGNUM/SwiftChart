//
//  ContentItemTextTableViewCell.swift
//  QOT
//
//  Created by karmic on 05.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class ContentItemTextTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Outlets

    @IBOutlet fileprivate weak var topLabel: UILabel!
    @IBOutlet fileprivate weak var bottomLabel: UILabel!
    weak var delegate: LearnContentItemViewController?

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .white
        backgroundColor = .white
    }

    func setup(topText: NSAttributedString, bottomText: NSAttributedString?) {
        bottomLabel.isHidden = bottomText == nil
        topLabel.attributedText = topText
        bottomLabel.attributedText = bottomText
    }
}
