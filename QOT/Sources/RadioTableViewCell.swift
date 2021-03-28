//
//  RadioTableViewCell.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright © 2021 Tignum. All rights reserved.
//

import UIKit

class RadioTableViewCell: UITableViewCell {

    @IBOutlet private weak var lableView: UIView!
    @IBOutlet private weak var radioStatusView: UIView!
    @IBOutlet private weak var bottomDivider: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var radioButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
