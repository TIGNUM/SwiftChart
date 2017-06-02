//
//  PrepareContentStepTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 11.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class PrepareContentStepTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var stepNumberLabel: UILabel!
    @IBOutlet weak var stepContentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    func setStepNumber(stepIndex: Index) {
        stepNumberLabel.text = stepIndex > 9 ? ".\(stepIndex)" : ".0\(stepIndex)"
    }

    func prepareAndSetTextAttributes(string: String) {
        let attrString = NSMutableAttributedString(string: string)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 13
        attrString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: string.characters.count))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "BentonSans-Book", size: 16)!, range: NSRange(location: 0, length: string.characters.count))
        stepContentLabel.attributedText = attrString
    }

}
