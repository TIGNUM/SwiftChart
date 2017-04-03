//
//  LearnStrategyVideoCell.swift
//  QOT
//
//  Created by tignum on 3/31/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class LearnStrategyVideoCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(with placeholderURL: URL, description: NSAttributedString) {
       descriptionLabel.attributedText = description
    }
}
