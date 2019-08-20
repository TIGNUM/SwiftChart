//
//  StrategyCategoryCollectionViewCell.swift
//  QOT
//
//  Created by karmic on 02.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class StrategyCategoryCollectionViewCell: ComponentCollectionViewCell {

    // MARK: - Properties

    @IBOutlet private weak var performanceLabel: UILabel!
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var bottomSeperator: UIView!

    func configure(categoryTitle: String, viewCount: Int, itemCount: Int) {
        let title = categoryTitle.replacingOccurrences(of: "Performance ", with: "")
        categoryTitleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                               letterSpacing: 0,
                                                               font: .apercuLight(ofSize: 20),
                                                               lineSpacing: 0,
                                                               textColor: .accent,
                                                               alignment: .left)
        let progress = String(format: "%d Seen of %d", viewCount, itemCount)
        progressLabel.attributedText = NSAttributedString(string: progress,
                                                          letterSpacing: 0,
                                                          font: .apercuRegular(ofSize: 12),
                                                          lineSpacing: 0,
                                                          textColor: .sand30,
                                                          alignment: .left)
    }

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
        backgroundColor = .clear

        let bkView = UIView()
        bkView.backgroundColor = .accent04
        selectedBackgroundView = bkView
    }
}
