//
//  MyStatisticsCardCell.swift
//  QOT
//
//  Created by karmic on 07.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MyStatisticsCardCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var subTitleLabel: UILabel!
    @IBOutlet fileprivate weak var teamAverageValueLabel: UILabel!
    @IBOutlet fileprivate weak var userAverageValueLabel: UILabel!
    @IBOutlet fileprivate weak var teamAverageLabel: UILabel!
    @IBOutlet fileprivate weak var userAverageLabel: UILabel!
    @IBOutlet fileprivate weak var teamLabel: UILabel!
    @IBOutlet fileprivate weak var userLabel: UILabel!
    @IBOutlet fileprivate weak var topContentView: UIView!
    @IBOutlet fileprivate weak var centerContentView: UIView!
    @IBOutlet fileprivate weak var bottomContentView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        topContentView.backgroundColor = .clear
        centerContentView.backgroundColor = .clear
        bottomContentView.backgroundColor = .clear
        layer.cornerRadius = 10
    }

    func setup(title: String, subTitle: String, data: [CGFloat], cardType: MyStatisticsCardType) {
        titleLabel.attributedText = Style.postTitle(title, .white).attributedString()
        subTitleLabel.attributedText = Style.tag(subTitle, .white40).attributedString()
        teamAverageValueLabel.attributedText = Style.tag(title, .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(title, .cherryRed).attributedString()
        teamAverageLabel.attributedText = Style.tag("AVG", .azure).attributedString()
        userAverageLabel.attributedText = Style.tag("AVG", .cherryRed).attributedString()
        teamLabel.attributedText = Style.tag("TEAM", .azure).attributedString()
        userLabel.attributedText = Style.tag("DATA", .cherryRed).attributedString()

        subTitleLabel.sizeToFit()
    }
}
