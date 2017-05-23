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
    @IBOutlet weak var CircleView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func setUp(title: String, subTitle: String, text: String) {
        titleLabel.text = text
        subTitleLabel.text = subTitle
        choiceLabel.text = title
    }

    private func configure() {
        CircleView.layer.cornerRadius = CircleView.bounds.width / 2
        titleLabel.font = UIFont.bentonRegularFont(ofSize: 20)
        subTitleLabel.font = UIFont.bentonRegularFont(ofSize: 20)
        choiceLabel.font = UIFont.bentonRegularFont(ofSize: 11)
    }
}
