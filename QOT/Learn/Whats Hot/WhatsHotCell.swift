//
//  WhatsHotCell.swift
//  QOT
//
//  Created by tignum on 4/13/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Kingfisher
class WhatsHotCell: UICollectionViewCell, Dequeueable {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var thoughtLabel: UILabel!
    @IBOutlet private weak var headlineLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 2
    }
    
    func setup(number: NSAttributedString, thought: NSAttributedString, headline: NSAttributedString, duration: NSAttributedString, placeholderURL: URL) {
        numberLabel.attributedText = number
        thoughtLabel.attributedText = thought
        headlineLabel.attributedText = headline
        durationLabel.attributedText = duration
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: placeholderURL)
    }
}
