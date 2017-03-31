//
//  LearnStrategyTextCell.swift
//  QOT
//
//  Created by tignum on 3/31/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class LearnStrategyTextCell: UITableViewCell, Dequeueable {
    
    @IBOutlet private weak var articleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(with title: NSAttributedString) {
       articleLabel.attributedText = title
    }
}
