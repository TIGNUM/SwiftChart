//
//  MyDataInfoTableViewCell.swift
//  QOT
//
//  Created by Voicu on 20.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyDataInfoTableViewCellDelegate: class {
    func didTapInfoButton(sender: MyDataInfoTableViewCell)
}

final class MyDataInfoTableViewCell: MyDataBaseTableViewCell {

    // MARK: - Properties
    weak var delegate: MyDataInfoTableViewCellDelegate?
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    private let infoText = " ⓘ"

    func configure(title: String?, subtitle: String?) {
        guard let title = title, let subtitle = subtitle else {
            return
        }
        ThemeText.myDataSectionHeaderTitle.apply(title, to: titleLabel)
        ThemeText.myDataSectionHeaderSubTitle.apply(subtitle, to: subtitleLabel)

        addInfoLink()
    }

    // MARK: Add the circle info charcter with tap action
    private func addInfoLink() {
        guard let subtitle = subtitleLabel.attributedText else {
            return
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleInfoTapped))
        subtitleLabel.addGestureRecognizer(tap)
        subtitleLabel.isUserInteractionEnabled = true
        let subtitleMutable = NSMutableAttributedString.init(attributedString: subtitle)
        let infoLinkAttributtedString: NSAttributedString = NSAttributedString(string: infoText,
                                                                               letterSpacing: 0.3,
                                                                               font: .apercuRegular(ofSize: 15),
                                                                               lineSpacing: 8,
                                                                               textColor: .accent,
                                                                               alignment: .left)
        subtitleMutable.append(infoLinkAttributtedString)
        subtitleLabel.attributedText = subtitleMutable
    }

    @objc private func handleInfoTapped(gesture: UITapGestureRecognizer) {
        guard let subtitleString = subtitleLabel.text else {
            return
        }
        let subtitle = NSString.init(string: subtitleString)
        let infoRange = subtitle.range(of: infoText)
        let tapLocation = gesture.location(in: subtitleLabel)
        let index = subtitleLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)

        if checkRange(infoRange, contain: index) == true {
            delegate?.didTapInfoButton(sender: self)
            return
        }
    }

    private func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
    }
}
