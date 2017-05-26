//
//  SettingsMenuCollectionViewCell.swift
//  QOT
//
//  Created by Type-IT on 20.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class SettingsMenuCollectionViewCell: UICollectionViewCell, Dequeueable {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.layer.cornerRadius = 10
    }
}
