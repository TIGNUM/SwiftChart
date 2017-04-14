//
//  PrepareEventsUpcomingTripTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 13.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class PrepareEventsUpcomingTripTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func prepareAndSetTextAttributes(string: String, label: UILabel, value: CGFloat) {
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSKernAttributeName, value: value, range: NSRange(location: 0, length: string.characters.count))
        label.attributedText = attrString
    }
}
