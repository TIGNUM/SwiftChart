//
//  PrePareCheckListContentItemTableViewCell.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class PrePareCheckListContentItemTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var headerMark: UIView!
    @IBOutlet private weak var bottomSeperator: UIView!
    @IBOutlet private weak var listMark: UIView!
    @IBOutlet private weak var editImageView: UIImageView!

    func configure(attributedString: NSAttributedString?,
                   hasListMark: Bool,
                   hasSeperator: Bool,
                   hasHeaderMark: Bool,
                   isEditable: Bool) {
        titleLabel.attributedText = attributedString
        headerMark.isHidden = !hasHeaderMark
        listMark.isHidden = !hasListMark
        bottomSeperator.isHidden = !hasSeperator
        editImageView.isHidden = !isEditable
    }
}
