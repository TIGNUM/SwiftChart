//
//  AbstractTableViewCell.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class AbstractTableViewCell: UITableViewCell, Dequeueable {

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
}
