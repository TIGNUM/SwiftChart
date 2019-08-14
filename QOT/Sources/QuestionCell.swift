//
//  QuestionCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class QuestionCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!

    func configure(with viewModel: QuestionCellViewModel?) {
        questionLabel.text = viewModel?.text
        titleLabel.text = viewModel?.title
    }
}
