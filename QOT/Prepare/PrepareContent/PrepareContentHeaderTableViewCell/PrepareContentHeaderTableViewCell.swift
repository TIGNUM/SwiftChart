//
//  PrepareContentHeaderTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 10.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class PrepareContentHeaderTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var verticalPlusBar: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        print("\(selected)")
        if selected {
            bottomSeparator.alpha = 0
            verticalPlusBar.alpha = 0
        }
    }
}
