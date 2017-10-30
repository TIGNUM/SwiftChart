//
//  MyPrepTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 14.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MyPrepTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet fileprivate weak var headerLabel: UILabel!
    @IBOutlet fileprivate weak var mainTextLabel: UILabel!
    @IBOutlet fileprivate weak var footerLabel: UILabel!
    @IBOutlet fileprivate weak var prepCount: UILabel!

    // MARK: - Initialisers

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupCell()
    }

    fileprivate func setupCell() {
        backgroundColor = .clear
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = UIColor.black15
        self.selectedBackgroundView = selectedBackground
    }

    // MARK: - Setup

    func setup(with header: String, text: String, footer: String, count: String) {
        headerLabel.attributedText = NSMutableAttributedString(
            string: header.uppercased(),
            letterSpacing: 2,
            font: Font.PTextSubtitle,
            textColor: Color.whiteish
        )
        mainTextLabel.attributedText = NSMutableAttributedString(
            string: text.uppercased(),
            letterSpacing: -0.8,
            font: Font.H4Headline,
            lineSpacing: 2
        )
        footerLabel.attributedText = NSMutableAttributedString(
            string: footer.uppercased(),
            letterSpacing: 2,
            font: Font.PTextSubtitle,
            textColor: Color.whiteLight
        )
        prepCount.attributedText = NSMutableAttributedString(
            string: count,
            letterSpacing: -0.8,
            font: Font.H4Headline
        )
    }
}
