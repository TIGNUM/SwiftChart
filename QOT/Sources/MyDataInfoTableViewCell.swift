//
//  MyDataInfoTableViewCell.swift
//  QOT
//
//  Created by Voicu on 20.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyDataInfoTableViewCellDelegate: class {
    func didTapInfoButton()
}

class MyDataInfoTableViewCell: UITableViewCell, Dequeueable {
    let infoText = " ⓘ"
    // MARK: - Properties

    weak var delegate: MyDataInfoTableViewCellDelegate?
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    func configure(title: String?, subtitle: String?) {
        guard let title = title, let subtitle = subtitle else {
            return
        }
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                       letterSpacing: 0,
                                                       font: .apercuRegular(ofSize: 20),
                                                       lineSpacing: 0,
                                                       textColor: .sand,
                                                       alignment: .left)
        subtitleLabel.attributedText = NSAttributedString(string: subtitle,
                                                          letterSpacing: 0,
                                                          font: .sfProtextRegular(ofSize: 14),
                                                          lineSpacing: 9,
                                                          textColor: .sand70,
                                                          alignment: .left)
        addInfoLink()
    }

    // MARK: Add the circle info charcter with tap action

    func addInfoLink() {
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

    @objc func handleInfoTapped(gesture: UITapGestureRecognizer) {
        guard let subtitleString = subtitleLabel.text else {
            return
        }
        let subtitle = NSString.init(string: subtitleString)
        let infoRange = subtitle.range(of: infoText)
        let tapLocation = gesture.location(in: subtitleLabel)
        let index = subtitleLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)

        if checkRange(infoRange, contain: index) == true {
            delegate?.didTapInfoButton()
            return
        }
    }

    func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
    }
}
