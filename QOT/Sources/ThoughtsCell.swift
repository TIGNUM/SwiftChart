//
//  ThoughtsCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ThoughtsCell: UITableViewCell, Dequeueable {
    @IBOutlet private weak var thoughtLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    func configure(with viewModel: ThoughtsCellViewModel?) {
        ThemeView.level2.apply(self)
        ThemeText.quotation.apply(viewModel?.thought, to: thoughtLabel)
        ThemeText.quoteAuthor.apply(viewModel?.author, to: authorLabel)
        ThemeText.dailyBriefTitle.apply((viewModel?.title ?? "").uppercased(), to: titleLabel)
    }
}
