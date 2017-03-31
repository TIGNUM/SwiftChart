//
//  LearnStrategyHeaderCell.swift
//  QOT
//
//  Created by tignum on 3/31/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnStrategyHeaderCell: UITableViewCell, Dequeueable {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with title: NSAttributedString, subTitle: NSAttributedString) {
        titleLabel.attributedText = title
        subTitleLabel.attributedText = subTitle
    }
}
