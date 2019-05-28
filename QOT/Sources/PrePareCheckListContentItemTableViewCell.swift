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

    func configure(attributedString: NSAttributedString?, hasListMark: Bool, hasSeperator: Bool, hasHeaderMark: Bool) {
        titleLabel.attributedText = attributedString
        headerMark.isHidden = !hasHeaderMark
        listMark.isHidden = !hasListMark
        bottomSeperator.isHidden = !hasSeperator
    }
}
