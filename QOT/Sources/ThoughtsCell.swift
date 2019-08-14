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
        thoughtLabel.text = viewModel?.thought
        authorLabel.text = viewModel?.author
        titleLabel.text = viewModel?.title
    }
}
