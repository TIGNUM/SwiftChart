//
//  ExploreCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ExploreCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var timeOfDayPosition: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var introTextLabel: UILabel!

    func configure(title: String?, introText: String?, labelPosition: CGFloat?) {
        titleLabel.text = title?.uppercased()
        introTextLabel.text = introText
        timeOfDayPosition.constant = labelPosition ?? 0
    }
}
