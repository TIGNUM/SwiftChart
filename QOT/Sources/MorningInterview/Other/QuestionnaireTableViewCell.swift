//
//  QuestionnaireTableViewCell.swift
//  QOT
//
//  Created by Sanggeon Park on 26.10.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

class QuestionnaireTableViewCell: UITableViewCell {
    @IBOutlet weak private var lineHeight: NSLayoutConstraint!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    override open var textLabel: UILabel? {
            return titleLabel
    }

    override open var detailTextLabel: UILabel? {
        return descriptionLabel
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lineHeight.constant = 0.5
    }

}
