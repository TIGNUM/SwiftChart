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

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addSubtitle(questionLabel)
    }

    func configure(with viewModel: QuestionCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: titleLabel)
        ThemeText.quotation.apply(model.text, to: questionLabel)
    }
}
