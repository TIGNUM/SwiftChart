//
//  ResultsPrepareQuestionDailyTableViewCell.swift
//  QOT
//
//  Created by karmic on 16.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class ResultsPrepareQuestionDailyTableViewCell: ResultsPrepareQuestionTableViewCell {

    @IBOutlet private weak var editImageView: UIImageView!

    func configure(title: String, canEdit: Bool) {
        editImageView.isHidden = !canEdit
        super.configure(title: title, firstItem: nil, secondItem: nil, thirdItem: nil)
    }
}
