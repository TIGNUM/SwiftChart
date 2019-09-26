//
//  ThoughtsCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ThoughtsCell: BaseDailyBriefCell {
    @IBOutlet private weak var thoughtLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(authorLabel)
        skeletonManager.addSubtitle(thoughtLabel)
    }

    func configure(with viewModel: ThoughtsCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        ThemeText.quotation.apply(model.thought, to: thoughtLabel)
        ThemeText.quoteAuthor.apply(model.author, to: authorLabel)
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: titleLabel)
    }
}
