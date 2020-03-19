//
//  ResultsPrepareEditableTableViewCell.swift
//  QOT
//
//  Created by karmic on 12.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class ResultsPrepareEditableTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var editImage: UIImageView!

    func configure(title: String, canEdit: Bool) {
        ThemeText.H02Light.apply(title, to: titleLabel)
        editImage.isHidden = !canEdit
    }
}
