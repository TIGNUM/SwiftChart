//
//  SigningInfoCollectionViewCell.swift
//  QOT
//
//  Created by karmic on 13.06.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningInfoCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
}

extension SigningInfoCollectionViewCell {

    func configure(title: String, body: String) {
        titleLabel.attributedText = NSMutableAttributedString(string: title,
                                                              letterSpacing: 1.5,
                                                              font: .simpleFont(ofSize: 24),
                                                              lineSpacing: 2,
                                                              textColor: .white,
                                                              alignment: .left)
        bodyLabel.attributedText = NSMutableAttributedString(string: body,
                                                             letterSpacing: 0.8,
                                                             font: .apercuLight(ofSize: 16),
                                                             lineSpacing: 8,
                                                             textColor: .white90,
                                                             alignment: .left)
    }
}
