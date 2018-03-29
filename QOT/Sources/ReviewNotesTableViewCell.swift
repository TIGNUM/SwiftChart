//
//  ReviewNotesTableViewCell.swift
//  QOT
//
//  Created by karmic on 27.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class ReviewNotesTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var noteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(title: String,
                   notes: String?,
                   reviewNotesType: PrepareContentReviewNotesTableViewCell.ReviewNotesType) {
        titleLabel.attributedText = NSMutableAttributedString(string: title,
                                                              letterSpacing: 2,
                                                              font: Font.PText,
                                                              lineSpacing: 10,
                                                              textColor: .black,
                                                              alignment: .left)
        var notesText = reviewNotesType.placeholder
        var font = Font.H7Tag
        if let notes = notes, notes.isEmpty == false {
            notesText = notes
            font = Font.PText
        }
        noteLabel.attributedText = NSMutableAttributedString(string: notesText,
                                                             letterSpacing: 2,
                                                             font: font,
                                                             lineSpacing: 10,
                                                             textColor: .black30,
                                                             alignment: .left,
                                                             lineBreakMode: .byWordWrapping)
    }
}
