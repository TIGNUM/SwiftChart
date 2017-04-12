//
//  PrepareContentTitleTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 11.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class PrepareContentTitleTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIFont(name: "Simple-Regular", size: 36.0)
    }
}
