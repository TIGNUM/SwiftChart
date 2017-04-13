//
//  WhatsHotCell.swift
//  QOT
//
//  Created by tignum on 4/13/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class WhatsHotCell: UICollectionViewCell, Dequeueable {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var thoughtLabel: UILabel!
    @IBOutlet private weak var headlineLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .red
    }
    
    func setup(number: NSAttributedString, thought: NSAttributedString, headline: NSAttributedString, duration: NSAttributedString) {
        numberLabel.attributedText = number
        thoughtLabel.attributedText = thought
        headlineLabel.attributedText = headline
        durationLabel.attributedText = duration
    }

}
