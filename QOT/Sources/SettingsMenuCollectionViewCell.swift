//
//  SettingsMenuCollectionViewCell.swift
//  QOT
//
//  Created by Type-IT on 20.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SettingsMenuCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Attributes

    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var cardView: UIView!

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.layer.cornerRadius = 10
    }

    // MARK: - Setup

    func setup(with title: String, subTitle: String) {
        timeLabel.attributedText = NSMutableAttributedString(string: title,
                                                             font: Font.H6NavigationTitle,
                                                             lineSpacing: 2)
        titleLabel.attributedText = NSMutableAttributedString(string: subTitle,
                                                              letterSpacing: 2,
                                                              font: Font.H7Tag,
                                                              lineSpacing: 3.2,
                                                              textColor: .white30)
    }
}
