//
//  WeeklyChoicesCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/16/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class WeeklyChoicesCell: UICollectionViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var choiceLabel: UILabel!
    @IBOutlet weak var circleView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        configure()
    }

    func setUp(title: String, subTitle: String, choice: String) {
        titleLabel.addCharactersSpacing(spacing: 1, text: title, uppercased: true)
        subTitleLabel.addCharactersSpacing(spacing: 1, text: subTitle, uppercased: true)
        choiceLabel.addCharactersSpacing(spacing: 2, text: choice, uppercased: true)
    }

    private func configure() {
        circleView.layer.cornerRadius = circleView.bounds.width / 2
        titleLabel.font = Font.H4Headline
        titleLabel.lineBreakMode = .byTruncatingTail
        subTitleLabel.font = Font.H7Title
        choiceLabel.font = Font.H7Tag
        subTitleLabel.textColor = .white60
        choiceLabel.textColor = .white50
    }
}
