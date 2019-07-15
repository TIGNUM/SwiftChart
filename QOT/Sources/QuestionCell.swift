//
//  QuestionCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class QuestionCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var questionLabel: UILabel!

    func configure(title: String?) {
        questionLabel.text = title
    }
}
