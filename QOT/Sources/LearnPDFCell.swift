//
//  LearnPDFCell.swift
//  QOT
//
//  Created by Moucheg Mouradian on 10/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Rswift

class LearnPDFCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet fileprivate weak var title: UILabel!
    @IBOutlet weak var timeToRead: UILabel!

    // MARK: - Methods

    func configure(titleText: NSAttributedString, timeToReadSeconds: Int) {
        title.attributedText = titleText
        title.textColor = .black
        title.lineBreakMode = .byTruncatingTail

        let startDate = Date().addingTimeInterval(TimeInterval(timeToReadSeconds))
        let timeToReadText = Date().timeToDateAsString(startDate) + " \(R.string.localized.learnContentItemToRead())"
        timeToRead.setAttrText(text: timeToReadText.uppercased(), font: Font.H7Tag, characterSpacing: 2)
        timeToRead.textColor = .black30
    }
}
