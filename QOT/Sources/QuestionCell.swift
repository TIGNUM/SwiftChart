//
//  QuestionCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class QuestionCell: BaseDailyBriefCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!

    func configure(with viewModel: QuestionCellViewModel?) {
        ThemeText.dailyBriefTitle.apply((viewModel?.title ?? "").uppercased(), to: titleLabel)
        ThemeText.quotation.apply(viewModel?.text, to: questionLabel)
    }
}
