//
//  QuestionnaireTableViewCell.swift
//  QOT
//
//  Created by Sanggeon Park on 26.10.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class QuestionnaireTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak public  var valueLabelWidth: NSLayoutConstraint!
    @IBOutlet weak public  var valueLabelLeading: NSLayoutConstraint!
    @IBOutlet weak public  var colorIndicator: QuestionaireCellIndicator!
    @IBOutlet weak public  var colorIndicatorTrailing: NSLayoutConstraint!

    override var textLabel: UILabel? {
        return titleLabel
    }

    override var detailTextLabel: UILabel? {
        return descriptionLabel
    }
}
