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

    @IBOutlet private weak var title: UILabel!
    @IBOutlet weak var timeToRead: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
    }

    // MARK: - Methods

    func configure(titleText: NSAttributedString, timeToReadSeconds: Int, titleColor: UIColor, timeColor: UIColor) {
        title.attributedText = titleText
        title.textColor = titleColor
        title.lineBreakMode = .byTruncatingTail
        let date = Date().addingTimeInterval(TimeInterval(timeToReadSeconds))
        var timeToReadText = ""
        if let timeString = DateComponentsFormatter.timeIntervalToString(date.timeIntervalSinceNow, isShort: true) {
            timeToReadText = "\(timeString)  \(R.string.localized.learnContentItemToRead())".uppercased()
        }
        timeToRead.setAttrText(text: timeToReadText, font: .H7Tag, characterSpacing: 2)
        timeToRead.textColor = timeColor
    }
}
