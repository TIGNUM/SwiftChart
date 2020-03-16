//
//  ResultsPrepareQuestionTableViewCell.swift
//  QOT
//
//  Created by karmic on 12.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

class ResultsPrepareQuestionTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var firstItemLabel: UILabel!
    @IBOutlet private weak var secondItemLabel: UILabel!
    @IBOutlet private weak var thirdItemLabel: UILabel!

    func configure(title: String, firstItem: String?, secondItem: String?, thirdItem: String?) {
        ThemeText.H02Light.apply(title, to: titleLabel)
        ThemeText.Text01Light.apply(firstItem, to: firstItemLabel)
        ThemeText.Text01Light.apply(secondItem, to: secondItemLabel)
        ThemeText.Text01Light.apply(thirdItem, to: thirdItemLabel)
    }
}
