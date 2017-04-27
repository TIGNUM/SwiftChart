//
//  LearnStrategyArticleCell.swift
//  QOT
//
//  Created by tignum on 3/31/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class LearnStrategyArticleCell: UITableViewCell, Dequeueable {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(with title: NSAttributedString, subtitle: NSAttributedString) {
        titleLabel.attributedText = title
        subTitleLabel.attributedText = subtitle
    }
}
