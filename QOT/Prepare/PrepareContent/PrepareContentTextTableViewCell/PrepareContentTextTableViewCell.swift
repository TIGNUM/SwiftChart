//
//  PrepareContentTextTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 10.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class PrepareContentTextTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func prepareAndSetTextAttributes(string: String) {
        let attrString = NSMutableAttributedString(string: string)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 13
        attrString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: string.characters.count))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "BentonSans-Book", size: 16)!, range: NSRange(location: 0, length: string.characters.count))
        contentLabel.attributedText = attrString
    }
}
