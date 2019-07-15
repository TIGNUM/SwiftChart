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

    func configure(thought: String?, author: String?) {
        thoughtLabel.text = thought
        authorLabel.text = author
    }
}
